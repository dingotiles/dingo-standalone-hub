class AddGuidToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :guid, :string
    Account.all.each do |acct|
      acct.send(:allocate_guid).save!
    end
  end
end
