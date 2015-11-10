module MigrateVideoFilesToS3
  # 7/17/2015
  # move video files from the old video server
  # from ~/storage/output/scenario_result_hash_id/result_video_hash_id.webm
  # to videos.asksonar.com/step_video_hash_id/video.webm
  # needed to decode old hash to new hash
  # needed to set content_type
  # can be re-run to overwrite all the files

  module_function
  @@s3 = Aws::S3::Client.new(
    region: 'us-west-1',
    access_key_id: 'AKIAJ43WUACRCS56MEQA',
    secret_access_key: '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'
  )

  # from old ResultVideo
  @@video_hash_decoder = Hashids.new("ResultVideof%jpdDF3c7ZZ@T&C7Zh^sk22gTKmxj#3", 8)
  # from new StepVideo
  @@video_hash_encoder = Hashids.new("Akn94V3&%9Tu", 8)

  def copy_to_s3(path)
    extension = File.extname(path)
    filename = File.basename(path, extension)

    id = @@video_hash_decoder.decode(filename)
    key = @@video_hash_encoder.encode(id) + '/video' + extension
    content_type = 'video/' + extension[1..-1]

    p path + ' => ' + key
    @@s3.put_object(bucket: 'videos.asksonar.com', key: key, body: File.new(path), content_type: content_type)
  end

  def migrate_videos(path)
    p 'migrating...'
    # Dir['~/sonar/storage/*/*'].map!(&:copy_to_s3)
    Dir[path].each { |path| copy_to_s3 path }
    p '...complete'
  end
end
