class AgentController < ApplicationController
  skip_before_action :verify_authenticity_token

  def register_cluster_node
    node_name = params[:node]
    cluster_name = params[:cluster]
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
      agent_spec[:archives][:aws_access_key_id] = required_env("AWS_ACCESS_KEY_ID")
			agent_spec[:archives][:aws_secret_access_id] = required_env("AWS_SECRET_ACCESS_KEY")
			agent_spec[:archives][:s3_bucket] = required_env("WAL_S3_BUCKET")
			agent_spec[:archives][:s3_endpoint] = required_env("WALE_S3_ENDPOINT")
    elsif ENV['SSH_HOST']
      agent_spec[:archives][:host] = required_env("SSH_HOST")
      agent_spec[:archives][:port] = required_env("SSH_PORT")
      agent_spec[:archives][:user] = required_env("SSH_USER")
      agent_spec[:archives][:private_key] = required_env("SSH_PRIVATE_KEY")
      agent_spec[:archives][:base_path] = required_env("SSH_BASE_PATH")
    else
      @missing_env_vars = ["AWS_ACCESS_KEY_ID or SSH_HOST"]
    end
    unless @missing_env_vars.empty?
      render status: 500, json: {"missing-env": @missing_env_vars}
    else
      render json: agent_spec
    end
  end

    # {
    #   cluster: {
    #     name: "",
    #     scope: ""
    #   },
    #   archives: {
    #     method: "s3",
    #     s3: {
    #       aws_access_key_id: "AKIAI5G7VDERAULCIVRQ",
    #       aws_secret_access_id: "9LuHhRBByimLaB8oBgXkNQH+R3sX1I392Pzk1gyn",
    #       s3_bucket: "pws-dingo-api-prod",
    #       s3_endpoint: "https+path://s3.amazonaws.com:443"
    #     },
    #     local: {},
    #     ssh: {}
    #   },

    private
    def required_env(key)
      @missing_env_vars ||= []
      @missing_env_vars << key unless ENV[key]
      ENV[key]
    end
end
