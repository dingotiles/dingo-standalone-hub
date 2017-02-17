class CreateClusters < ActiveRecord::Migration[5.0]
  def change
    create_table :clusters do |t|
      t.references :account, foreign_key: true
      t.string :name
      t.string :archive_method

      t.timestamps
    end
  end
end
