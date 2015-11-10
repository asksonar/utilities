require 'ff_mpeg_helper'

class FfMpegHelper

  def self.run_command!(system_command)
    p 'running command: ' + system_command
    if not system system_command
      raise 'Failed to run command: ' + system_command
    end
    p 'finished command: ' + system_command
  end

  def self.fast_concat_video(first_path, second_path, output_path, extension)
    list_file = Tempfile.new('list')
    list_file.puts("file '#{first_path}'", "file '#{second_path}'")
    list_file.flush
    run_command!("ffmpeg -y -f concat -i #{list_file.path} -c copy -f #{extension} #{output_path}")
  end

  def self.accurate_concat_video(first_path, second_path, output_path, extension)
    run_command!("ffmpeg -y -i #{first_path} -i #{second_path} \
      -filter_complex '[0:v:0] [0:a:0] [1:v:0] [1:a:0] concat=n=2:v=1:a=1 [v] [a]' \
      -map '[v]' -map '[a]' -f #{extension} #{output_path}")
  end

  def self.fast_append_video(append_to_me_path, append_me_path, extension)
    append_to_me_copy = Tempfile.new("original_video")
    begin
      FileUtils.copy_file(append_to_me_path, append_to_me_copy.path)
      fast_concat_video(append_to_me_copy.path, append_me_path, append_to_me_path, extension)
    ensure
      append_to_me_copy.close!
    end
  end

  def self.accurate_append_video(append_to_me_path, append_me_path, extension)
    append_to_me_copy = Tempfile.new("original_video")
    begin
      FileUtils.copy_file(append_to_me_path, append_to_me_copy.path)
      accurate_concat_video(append_to_me_copy.path, append_me_path, append_to_me_path, extension)
    ensure
      append_to_me_copy.close!
    end
  end
end
