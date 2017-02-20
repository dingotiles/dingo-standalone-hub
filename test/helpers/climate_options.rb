module ClimateOptionsHelper
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

  def global_etcd_options
    {
      "ETCD_URI": "http://localhost:4001",
    }
  end

  def with_global_archive_s3(&block)
    options = global_archive_s3_options.merge(global_etcd_options)
    ClimateControl.modify(options, &block)
  end

  def with_global_archive_ssh(&block)
    options = global_archive_ssh_options.merge(global_etcd_options)
    ClimateControl.modify(options, &block)
  end

  def with_global_etcd(&block)
    options = global_etcd_options.merge(global_archive_s3_options)
    ClimateControl.modify(options, &block)
  end

  def with_global(&block)
    options = global_etcd_options.merge(global_archive_s3_options)
    ClimateControl.modify(options, &block)
  end

end
