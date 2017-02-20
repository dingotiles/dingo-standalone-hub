class CreateArchives < ActiveRecord::Migration[5.0]
  def change
    create_table :archives do |t|
      t.string :method
      t.json :credentials
      t.references :account, foreign_key: true

      t.timestamps
    end
    Account.all.each do |acct|
      acct.send(:provision_cluster_archive)
    end
  end
end
