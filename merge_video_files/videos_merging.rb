module MergeVideoFilesInS3
  class VideosMerging

    def initialize (videos)
      @videos = videos
    end

    def merge_videos
      byebug
      @videos[1..-1].each { |video| merge_video(video) }
      byebug
      first_video.upload
    end

    private

    def ffmpeg_helper
      @ffmpeg_helper ||= FfMpegHelper
    end

    def first_video
      @first_video ||= VideoDownload.new(@videos[0])
    end

    def merge_video(video)
      byebug
      video_download = VideoDownload.new(video)
      append_video(video_download, 'mp4')
      append_video(video_download, 'webm')
      # video_download.delete
      # video.delete
    end

    def append_video(append_me, extension)
      byebug
      first_path = first_video.send(extension + '_path')
      append_me_path = append_me.send(extension + '_path')
      ffmpeg_helper.accurate_append_video(first_path, append_me_path, extension)
    end
  end
end
