class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :email

      t.timestamps
    end
    add_index :accounts, :email
  end
end
