class CreateClusterNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :cluster_nodes do |t|
      t.references :cluster, foreign_key: true
      t.string :name
      t.string :image_version
      t.string :state, default: "starting"
      t.string :role

      t.timestamps
    end
  end
end
