class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.references :account, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
