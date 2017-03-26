# Archive describes how and where all databases
# for an Account archives backups
class Archive < ApplicationRecord
  belongs_to :account
end
