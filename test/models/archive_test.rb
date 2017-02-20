require 'test_helper'

class ArchiveTest < ActiveSupport::TestCase
  test "loads credentials json" do
    archive = archives(:known)
    assert_equal archive.method, "s3"
    assert archive.credentials["aws_access_key_id"]
    assert archive.credentials["aws_secret_access_id"]
    assert archive.credentials["s3_bucket"]
    assert archive.credentials["s3_endpoint"]
  end
end
