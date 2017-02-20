module EtcdOptionsHelper
  def global_etcd_options
    {
      "ETCD_URI": "http://localhost:4001",
    }
  end
end
