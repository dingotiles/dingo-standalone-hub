class AgentController < ApplicationController
  skip_before_action :verify_authenticity_token

  def register_cluster_node
    account_email = params[:account]
    account = Account.find_or_create_by(email: account_email)
    node_name = params[:node]
    cluster_name = params[:cluster]
    cluster = Cluster.find_or_create_by(name: cluster_name, account: account)
    cluster.cluster_nodes.find_or_create_by(name: node_name)

    image_version = params[:image_version]
    agent_spec = {
      cluster: {
        name: node_name,
        scope: cluster_name,
      },
      archives: {},
      etcd: {
        uri: ENV['ETCD_URI'],
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
    if ENV['AWS_ACCESS_KEY_ID']
      agent_spec[:archives][:method] = "s3"
      agent_spec[:archives][:s3] = {}
      agent_spec[:archives][:s3][:aws_access_key_id] = required_env("AWS_ACCESS_KEY_ID")
			agent_spec[:archives][:s3][:aws_secret_access_id] = required_env("AWS_SECRET_ACCESS_KEY")
			agent_spec[:archives][:s3][:s3_bucket] = required_env("WAL_S3_BUCKET")
			agent_spec[:archives][:s3][:s3_endpoint] = required_env("WALE_S3_ENDPOINT")
    elsif ENV['SSH_HOST']
      agent_spec[:archives][:method] = "ssh"
      agent_spec[:archives][:ssh] = {}
      agent_spec[:archives][:ssh][:host] = required_env("SSH_HOST")
      agent_spec[:archives][:ssh][:port] = required_env("SSH_PORT")
      agent_spec[:archives][:ssh][:user] = required_env("SSH_USER")
      agent_spec[:archives][:ssh][:private_key] = required_env("SSH_PRIVATE_KEY")
      agent_spec[:archives][:ssh][:base_path] = required_env("SSH_BASE_PATH")
    else
      @missing_env_vars = ["AWS_ACCESS_KEY_ID or SSH_HOST"]
    end
    unless @missing_env_vars.empty?
      render status: 500, json: {"missing-env": @missing_env_vars}
    else
      render json: agent_spec
    end
  end

    private
    def required_env(key)
      @missing_env_vars ||= []
      @missing_env_vars << key unless ENV[key]
      ENV[key]
    end
end
