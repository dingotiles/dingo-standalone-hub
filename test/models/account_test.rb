require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  include ClimateOptionsHelper

  test "on create allocates s3 archive & credentials" do
    assert_difference "Archive.count", +1 do
      with_global do
        @account = Account.create
      end
    end
    archive = @account.archive
    assert_equal archive.method, "s3"
    s3 = archive.credentials
    assert_equal "key", s3["aws_access_key_id"]
    assert_equal "secret", s3["aws_secret_access_id"]
    assert_equal "bucket", s3["s3_bucket"]
    assert_equal "endpoint", s3["s3_endpoint"]
  end

  test "on create provisions broker s3 archive & credentials" do
    assert_difference "Archive.count", +1 do
      with_broker_archive_s3 do
        @account = Account.create
      end
    end
    archive = @account.archive
    assert_equal archive.method, "s3"
    s3 = archive.credentials
    assert_equal "broker-key", s3["aws_access_key_id"]
    assert_equal "broker-secret", s3["aws_secret_access_id"]
    assert_equal "dingo-hub-s3-testing-test1", s3["s3_bucket"]
    assert_equal "https+path://s3-us-east-2.amazonaws.com:443", s3["s3_endpoint"]
  end
end
