# Central Hub for Dingo PostgreSQL for Docker

**PRIVATE: This is our PostgreSQL Backups & HA orchestration as a Service product. See dingo-postgresql-agent for the OSS client, which includes a `test-api` for testing the agent. This repo shares some structs with agent code.**

All Dingo PostgreSQL agent nodes connect first to this API to request credentials & configuration.

Users can manage all their clusters via a web UI.

## Development

This Rails web app can be deployed in a small Docker cluster with a test dingo-postgresql-agent container:

```
docker-compose up --build
```

**NOTE: `dingotiles/dingo-standalone-hub` image is not a public image and should only be created for purposes of dev/testing.**

### Deploying to Cloud Foundry

See `ci/pipeline.yml` for required environment variables.
