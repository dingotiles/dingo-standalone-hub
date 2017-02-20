class Account < ApplicationRecord
  has_many :clusters, dependent: :destroy
  has_one :archive, dependent: :destroy

  before_create :allocate_guid
  after_create_commit :provision_cluster_archive

  private
  def allocate_guid
    self.guid = SecureRandom.hex(10)
    self
  end

  def provision_cluster_archive
    archive = self.build_archive
    creds = {}
    @missing_env_vars = []
    if ENV['S3_BROKER_URL']
      archive.method = "s3"
      creds = broker_provision_s3_bucket_creds
    elsif ENV['AWS_ACCESS_KEY_ID']
      archive.method = "s3"
      creds = global_s3_creds
    elsif ENV['SSH_HOST']
      archive.method = "ssh"
      creds = global_ssh_creds
    else
      archive.method = "unknown"
      raise "$S3_BROKER_URL or $AWS_ACCESS_KEY_ID or $SSH_HOST required to configure archives"
    end
    unless @missing_env_vars.empty?
      raise "Env vars #{@missing_env_vars.join(', ')} are required to configure #{archive.method} archives"
    end
    archive.credentials = creds
    archive.save!
  end

  def required_env(key)
    @missing_env_vars ||= []
    @missing_env_vars << key unless ENV[key]
    ENV[key]
  end

  def broker_provision_s3_bucket_creds
    binding_credentials = S3BrokerClient.new.provision_and_return_credentials(guid, guid)
    # have seen new credentials fail for new accounts; so wait a moment before providing them
    self.class.wait_for_bucket
    {
      "aws_access_key_id": binding_credentials["credentials"]["access_key_id"],
      "aws_secret_access_id": binding_credentials["credentials"]["secret_access_key"],
      "s3_bucket": binding_credentials["credentials"]["bucket"],
      "s3_endpoint": "https+path://#{binding_credentials["credentials"]["host"]}:443",
    }
  end

  def global_s3_creds
    {
      "aws_access_key_id": required_env("AWS_ACCESS_KEY_ID"),
      "aws_secret_access_id": required_env("AWS_SECRET_ACCESS_KEY"),
      "s3_bucket": required_env("WAL_S3_BUCKET"),
      "s3_endpoint": required_env("WALE_S3_ENDPOINT"),
    }
  end

  def global_ssh_creds
    {
      "host": required_env("SSH_HOST"),
      "port": required_env("SSH_PORT"),
      "user": required_env("SSH_USER"),
      "private_key": required_env("SSH_PRIVATE_KEY"),
      "base_path": required_env("SSH_BASE_PATH"),
    }
  end

  def self.wait_for_bucket
    sleep 5
  end
end
