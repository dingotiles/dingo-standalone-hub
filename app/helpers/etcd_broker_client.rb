class EtcdBrokerClient
  attr_reader :url, :username, :password, :service_id, :plan_id

  def initialize
    @service_id = ENV['ETCD_BROKER_SERVICE_ID']
    @plan_id = ENV['ETCD_BROKER_PLAN_ID']
    broker_uri = URI(ENV['ETCD_BROKER_URI'])
    @username = broker_uri.user
    @password = broker_uri.password
    broker_uri.user = nil
    broker_uri.password = nil
    @url = broker_uri.to_s
  end

  def provision_and_return_credentials(instance_id, binding_id)
    if provision(instance_id)
      binding(instance_id, binding_id)
    else
      nil
    end
  end

  def provision(instance_id)
    data = {"service_id": service_id, "plan_id": plan_id,
        "organization_guid": "org", "space_guid": "space"}

    uri = URI("#{url}/v2/service_instances/#{instance_id}")
    req = Net::HTTP::Put.new(uri.path)
    req.basic_auth username, password
    req.content_type = 'application/json'
    req.body = data.to_json

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.read_timeout = 60 # seconds
      http.request(req)
    end

    res.is_a? Net::HTTPSuccess
  end

  def binding(instance_id, binding_id)
    data = {"service_id": service_id, "plan_id": plan_id, "app_guid": "app"}

    uri = URI("#{url}/v2/service_instances/#{instance_id}/service_bindings/#{binding_id}")
    req = Net::HTTP::Put.new(uri.path)
    req.basic_auth username, password
    req.content_type = 'application/json'
    req.body = data.to_json

    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.read_timeout = 60 # seconds
      http.request(req)
    end

    Rails.logger.info("etcd-broker PUT #{url}/v2/service_instances/#{instance_id}/service_bindings/#{binding_id}: " + res.body)
    JSON.parse(res.body) if res.is_a? Net::HTTPSuccess
  rescue => e
    Rails.logger.info("etcd-broker PUT #{url}/v2/service_instances/#{instance_id}/service_bindings/#{binding_id} errored: " + e.message)
    nil
  end
end
