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
      "S3_BROKER_URL": "http://s3-broker.dev",
      "S3_BROKER_USERNAME": "broker",
      "S3_BROKER_PASSWORD": "password",
      "S3_BROKER_SERVICE_ID": "amazon-s3",
      "S3_BROKER_PLAN_ID": "bucket",
    }
  end


  def global_etcd_options
    {
      "ETCD_URI": "http://global.shared.db:4001",
      "ETCD_BROKER_URI": nil,
    }
  end

  def broker_etcd_options
    {
      "ETCD_URI": nil,
      "ETCD_BROKER_URI": "http://broker:password@etcd.broker:6000",
    }
  end

  def with_global_archive_s3(&block)
    options = global_archive_s3_options.merge(global_etcd_options)
    ClimateControl.modify(options, &block)
  end

  def with_broker_archive_s3(&block)
    # s3-cf-service-broker returns:
    binding_credentials = {
      "syslog_drain_url": nil,
      "credentials": {
        "access_key_id": "broker-key",
        "secret_access_key": "broker-secret",
        "bucket": "dingo-hub-s3-testing-test1",
        "host": "s3-us-east-2.amazonaws.com",
        "uri": "s3://broker-key:broker-secret@s3-us-east-2.amazonaws.com/dingo-hub-s3-testing-test1",
        "username": "dingo-hub-s3-testing-user1",
      }
    }
    stub_request(:put, %r{^http://s3-broker.dev/v2/service_instances/\w+$}).
      with(headers: {"Content-Type" => "application/json"}).
      to_return(body: {"dashboard_url" => nil}.to_json)
    stub_request(:put, %r{^http://s3-broker.dev/v2/service_instances/\w+/service_bindings/\w+$}).
      with(headers: {"Content-Type" => "application/json"}).
      to_return(body: binding_credentials.to_json)
    Account.stub :wait_for_bucket, nil do
      options = broker_archive_s3_options.merge(global_etcd_options)
      ClimateControl.modify(options, &block)
    end
  end

  def with_global_archive_ssh(&block)
    options = global_archive_ssh_options.merge(global_etcd_options)
    ClimateControl.modify(options, &block)
  end

  def with_global_etcd(&block)
    options = global_etcd_options.merge(global_archive_s3_options)
    ClimateControl.modify(options, &block)
  end

  def with_broker_etcd(&block)
    binding_credentials = {
      "credentials": {
        "uri": "http://user-abcdef:password@etcd.cluster:4001",
        "keypath": "/service_instances/qwerty",
        "host": "http://etcd.cluster:4001",
        "username": "user-abcdef",
        "password": "password"
      }
    }
    stub_request(:put, %r{^http://etcd.broker:6000/v2/service_instances/\w+$}).
      with(headers: {"Content-Type" => "application/json"}).
      to_return(body: {"dashboard_url" => nil}.to_json)
    stub_request(:put, %r{^http://etcd.broker:6000/v2/service_instances/\w+/service_bindings/\w+$}).
      with(headers: {"Content-Type" => "application/json"}).
      to_return(body: binding_credentials.to_json)
    options = broker_etcd_options.merge(global_archive_s3_options)
    ClimateControl.modify(options, &block)
  end

  def with_global(&block)
    options = global_etcd_options.merge(global_archive_s3_options)
    ClimateControl.modify(options, &block)
  end

end
