module ClimateOptionsHelper
  def global_archive_s3_options
    {
      "S3_BROKER_URL": nil,
      "SSH_HOST": nil,
      "AWS_ACCESS_KEY_ID": "key",
      "AWS_SECRET_ACCESS_KEY": "secret",
      "WAL_S3_BUCKET": "bucket",
      "WALE_S3_ENDPOINT": "endpoint",
    }
  end

  def global_archive_ssh_options
    {
      "AWS_ACCESS_KEY_ID": nil,
      "S3_BROKER_URL": nil,
      "SSH_HOST": "localhost",
      "SSH_PORT": "22",
      "SSH_USER": "dingo",
      "SSH_PRIVATE_KEY": "inline-key",
      "SSH_BASE_PATH": "/data/",
    }
  end

  def broker_archive_s3_options
    {
      "AWS_ACCESS_KEY_ID": nil,
      "SSH_HOST": nil,
      "S3_BROKER_URL": "http://localhost:8080",
      "S3_BROKER_USERNAME": "broker",
      "S3_BROKER_PASSWORD": "password",
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

  def with_broker_archive_s3(&block)
    # TODO: what to stub out
    # expecting binding credentials to be:
    # assert_equal "broker-key", s3["aws_access_key_id"]
    # assert_equal "broker-secret", s3["aws_secret_access_id"]
    # assert_equal "dingo-hub-s3-testing-test1", s3["s3_bucket"]
    # assert_equal "https+path://s3-us-east-2.amazonaws.com:443", s3["s3_endpoint"]
    #
    # endpoint should look like: https+path://s3-us-east-2.amazonaws.com:443
    # => "https+path://#{host}:443"
    #
    # s3-cf-service-broker returns:
    # {
    #   "syslog_drain_url": null,
    #   "credentials": {
    #     "bucket": "dingo-hub-s3-testing-test1",
    #     "access_key_id": "AKIAJKG5FVGTKR3ZOL6Q",
    #     "secret_access_key": "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",
    #     "host": "s3.amazonaws.com",
    #     "uri": "s3://AKIAJKG5FVGTKR3ZOL6Q:i8et41UiJ9YfPsn%2FtA%2FQR5Ky41%2B8woGdjThd7LEs@s3.amazonaws.com/dingo-hub-s3-staging-test1",
    #     "username": "dingo-hub-s3-staging-me1"
    #   }
    # }
    options = broker_archive_s3_options.merge(global_etcd_options)
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
