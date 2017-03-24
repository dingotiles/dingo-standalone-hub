class AddImageNameToClusterNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :cluster_nodes, :image_name, :string
    add_column :cluster_nodes, :agent_version, :string
  end
end
