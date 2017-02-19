class AddStateToCluster < ActiveRecord::Migration[5.0]
  def change
    add_column :clusters, :state, :string, default: "starting"
  end
end
