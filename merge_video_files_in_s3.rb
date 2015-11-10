require_rel 'merge_video_files'

module MergeVideoFilesInS3
  # 11/5/2015
  # first, backup videos that don't have uuid backups
  # then, group videos by scenario_result to merge
  #
  # the first step_video will keep its name
  # while the others will then disappear
  #
  # will skip videos if there's only one step
  # therefore if re-run, will ignore videos that are already processed
  #
  # if we want to redo the process from scratch, we'll need to
  # 1) delete items that have UUID backups and re-encode them from the UUID videos
  # 2) restore items that don't have UUID from backup and re-merge them

  module_function

  # TODO: change me depending on how the database is set up
  def scenario_results_with_videos
    scenario_result_id_to_count = StepVideo
      .where.not(result_step_id: nil) # most likely aborted during uploaded
      .group(:scenario_result_id).count
    scenario_result_ids_with_videos = scenario_result_id_to_count.select { |key, value| value > 1 }
    ScenarioResult.where(id: scenario_result_ids_with_videos.keys)
  end

  # TODO: change me depending on how the database is setup
  def step_videos_without_uuid
    StepVideo.where(uuid: nil)
  end

  def backup
    step_videos_without_uuid.limit(1).each do |video|
      VideoBackup.new(video).backup_video
    end
  end

  def merge
    scenario_results_with_videos.limit(1).each do |scenario_result|
      VideosMerging.new(scenario_result.step_videos).merge_videos
    end
  end
end
