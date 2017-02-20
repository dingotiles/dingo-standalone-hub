class Account < ApplicationRecord
  has_many :clusters, dependent: :destroy
  has_one :archive, dependent: :destroy

  after_create_commit :provision_cluster_archive

  private
  def provision_cluster_archive
    archive = self.build_archive
    creds = {}
    if ENV['AWS_ACCESS_KEY_ID']
      archive.method = "s3"
      creds["aws_access_key_id"] = required_env("AWS_ACCESS_KEY_ID")
			creds["aws_secret_access_id"] = required_env("AWS_SECRET_ACCESS_KEY")
			creds["s3_bucket"] = required_env("WAL_S3_BUCKET")
			creds["s3_endpoint"] = required_env("WALE_S3_ENDPOINT")
    elsif ENV['SSH_HOST']
      archive.method = "ssh"
      creds["host"] = required_env("SSH_HOST")
      creds["port"] = required_env("SSH_PORT")
      creds["user"] = required_env("SSH_USER")
      creds["private_key"] = required_env("SSH_PRIVATE_KEY")
      creds["base_path"] = required_env("SSH_BASE_PATH")
    else
      archive.method = "unknown"
      raise "$AWS_ACCESS_KEY_ID or $SSH_HOST required to configure archives"
    end
    unless @missing_env_vars.empty?
      raise "Env vars #{@missing_env_vars.join(', ')} are required to configure #{archive.method}} archives"
    end
    archive.credentials = creds
    archive.save!
  end

  def required_env(key)
    @missing_env_vars ||= []
    @missing_env_vars << key unless ENV[key]
    ENV[key]
  end
end
