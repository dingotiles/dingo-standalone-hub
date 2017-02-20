class CreateClusterEtcds < ActiveRecord::Migration[5.0]
  def change
    create_table :cluster_etcds do |t|
      t.json :credentials
      t.references :cluster, foreign_key: true

      t.timestamps
    end
    Cluster.all.each do |cluster|
      cluster.send(:provision_cluster_etcd)
    end
  end
end
