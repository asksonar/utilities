module MergeVideoFilesInS3
  class VideoBackup
    def initialize (video)
      @video = video
    end

    def hashid
      @video.hashid
    end

    def backup_video
      s3_helper.backup_video_from_s3_videos(hashid + '/video.mp4')
      s3_helper.backup_video_from_s3_videos(hashid + '/video.webm')
    end

    private

    def s3_helper
      @s3_helper ||= S3Helper.new
    end
  end
end
