class CreateClusterNodeEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :cluster_node_events do |t|
      t.references :cluster, foreign_key: true
      t.string :name
      t.string :image_version

      t.timestamps
    end
  end
end
