class CreateArchives < ActiveRecord::Migration[5.0]
  def change
    create_table :archives do |t|
      t.string :method
      t.json :credentials
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
