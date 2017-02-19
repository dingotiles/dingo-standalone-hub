class Account < ApplicationRecord
  has_many :clusters, dependent: :destroy
end
