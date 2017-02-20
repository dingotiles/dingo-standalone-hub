class AgentController < ApplicationController
  skip_before_action :verify_authenticity_token

  def register_cluster_node
    cluster_name = params[:cluster]
    node_name = params[:node]
    begin
      account = Account.find_or_create_by(email: params[:account])
      @cluster = account.clusters.find_or_create_by(name: cluster_name)
    rescue => e
      render status: 500, json: {"missing-env": e.message}
      return
    end
    @cluster.cluster_nodes.find_or_create_by(name: node_name) do |node|
      node.image_version = params[:image_version]
    end

    image_version = params[:image_version]
    agent_spec = {
      cluster: {
        name: node_name,
        scope: cluster_name,
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
