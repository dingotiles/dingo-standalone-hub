class AddGuidToCluster < ActiveRecord::Migration[5.0]
  def change
    add_column :clusters, :guid, :string
    Cluster.all.each do |cluster|
      cluster.send(:allocate_guid).save!
    end
  end
end
