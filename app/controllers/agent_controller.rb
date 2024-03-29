class AgentController < ApplicationController
  skip_before_action :verify_authenticity_token

  def register_cluster_node
    cluster_name = params[:cluster]
    node_name = params[:node]
    unless cluster_name && node_name
      render status: 400, json: {"error": "Missing required params 'cluster' and/or 'node'"}
      return
    end
    begin
      account = Account.find_or_create_by(email: params[:account])
      @cluster = account.clusters.find_or_create_by(name: cluster_name)
    rescue => e
      Rails.logger.info e.backtrace
      render status: 500, json: {"error": e.message}
      return
    end
    node = @cluster.cluster_nodes.find_or_initialize_by(name: node_name) do |node|
      node.agent_version = params[:agent_version]
      node.image_version = params[:image_version]
      node.image_name    = params[:image_name]
    end
    node.state = "initialized"
    node.save!
    @cluster.update_state_from_nodes!

    image_version = params[:image_version]
    agent_spec = {
      cluster: {
        name: node_name,
        scope: cluster_name,
        namespace: @cluster.etcd_namespace,
      },
      archives: {},
      etcd: {
        uri: @cluster.cluster_etcd.uri,
      },
      postgresql: {
        admin: {
          password: "admin-password"
        },
        appuser: {
          password: "appuser-password",
          username: "appuser-username"
        },
        superuser: {
          password: "superuser-password",
          username: "superuser-username"
        }
      }
    }
    if account.archive.method == "s3"
      agent_spec[:archives][:method] = "s3"
      agent_spec[:archives][:s3] = account.archive.credentials
    elsif account.archive.method == "ssh"
      agent_spec[:archives][:method] = "ssh"
      agent_spec[:archives][:ssh] = account.archive.credentials
    end
    render json: agent_spec
  end

    private
    def required_env(key)
      @missing_env_vars ||= []
      @missing_env_vars << key unless ENV[key]
      ENV[key]
    end
end
