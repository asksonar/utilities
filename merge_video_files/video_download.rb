module MergeVideoFilesInS3
  class VideoDownload
    def initialize (video)
      @video = video
    end

    def hashid
      @video.hashid
    end

    def webm_path
      return @webm_file.path if @webm_file

      temp_file = Tempfile.new(hashid + '.webm')
      s3_helper.download_video_from_s3_videos("#{hashid}/video.webm", temp_file.path)
      @webm_file = temp_file
      @webm_file.path
    end

    def mp4_path
      return @mp4_file.path if @mp4_file

      temp_file = Tempfile.new(hashid + '.mp4')
      s3_helper.download_video_from_s3_videos("#{hashid}/video.mp4", temp_file.path)
      @mp4_file = temp_file
      @mp4_file.path
    end

    def upload
      s3_helper.upload_video_to_s3_videos(webm_path, "#{hashid}/video.webm", 'video/webm')
      s3_helper.upload_video_to_s3_videos(mp4_path, "#{hashid}/video.mp4", 'video/mp4')
    end

    def delete
      s3_helper.delete_video_from_s3_videos("#{hashid}/video.webm")
      s3_helper.delete_video_from_s3_videos("#{hashid}/video.mp4")
    end

    private

    def s3_helper
      @s3_helper ||= S3Helper.new
    end
  end
end
