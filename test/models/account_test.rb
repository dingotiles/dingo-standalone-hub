require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  test "on create allocates s3 archive & credentials" do
    assert_difference "Archive.count", +1 do
      @account = Account.create
    end
    archive = @account.archive
    assert_equal archive.method, "s3"
    assert archive.credentials["aws_access_key_id"]
    assert archive.credentials["aws_secret_access_id"]
    assert archive.credentials["s3_bucket"]
    assert archive.credentials["s3_endpoint"]
  end
end
