namespace :etcd do
  desc "Watch etcd for changes in clusters"
  task :watch do
    etcd_uri = URI(ENV['ETCD_URI'])
    client = Etcd.client(host: etcd_uri.host, port: etcd_uri.port,
      use_ssl: etcd_uri.scheme == "https",
      user_name: etcd_uri.user, password: etcd_uri.password)
    
  end
end
