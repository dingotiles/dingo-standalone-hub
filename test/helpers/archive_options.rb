module ArchiveOptionsHelper
  def global_archive_s3_options
    {
      "AWS_ACCESS_KEY_ID": "key",
      "AWS_SECRET_ACCESS_KEY": "secret",
      "WAL_S3_BUCKET": "bucket",
      "WALE_S3_ENDPOINT": "endpoint",
      "SSH_HOST": nil,
    }
  end

  def global_archive_ssh_options
    {
      "AWS_ACCESS_KEY_ID": nil,
      "SSH_HOST": "localhost",
      "SSH_PORT": "22",
      "SSH_USER": "dingo",
      "SSH_PRIVATE_KEY": "inline-key",
      "SSH_BASE_PATH": "/data/",
    }
  end
end
