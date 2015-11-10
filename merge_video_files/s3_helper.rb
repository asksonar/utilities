require 's3_helper'

# reopen class
class S3Helper
  def download_video_from_s3_videos(bucket_path, local_path)
    bucket = s3.bucket(S3_VIDEOS_BUCKET)
    object = bucket.object(bucket_path)
    object.get({
      response_target: local_path
    })
    Rails.logger.info 'downloaded from: ' + S3_VIDEOS_BUCKET + '/' + bucket_path + ' to: ' + local_path
  end

  def download_video_from_s3_backup(bucket_path, local_path)
    bucket = s3.bucket(S3_BACKUP_BUCKET)
    object = bucket.object(bucket_path)
    object.get({
      response_target: local_path
    })
    Rails.logger.info 'downloaded from: ' + S3_BACKUP_BUCKET + '/' + bucket_path + ' to: ' + local_path
  end

  alias upload_video_to_s3_videos upload_video

  def delete_video_from_s3_videos(bucket_path)
    bucket = s3.bucket(S3_VIDEOS_BUCKET)
    object = bucket.object(bucket_path)
    object.delete
    Rails.logger.info 'deleted from: ' + S3_VIDEOS_BUCKET + '/' + bucket_path
  end

  def backup_video_from_s3_videos(bucket_path)
    backup(S3_VIDEOS_BUCKET, bucket_path)
  end
end
