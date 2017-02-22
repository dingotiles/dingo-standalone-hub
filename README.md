# Central Hub for Dingo PostgreSQL for Docker

**PRIVATE: This is our PostgreSQL Backups & HA orchestration as a Service product. See dingo-postgresql-agent for the OSS client, which includes a `test-api` for testing the agent. This repo shares some structs with agent code.**

All Dingo PostgreSQL agent nodes connect first to this API to request credentials & configuration.

Users can manage all their clusters via a web UI.

## Development

This Rails web app can be played with in a small Docker cluster with a test `dingo-postgresql-agent` container:

```
docker-compose up --build
```

**NOTE: `dingotiles/dingo-standalone-hub` image is not a public image and should only be created for purposes of dev/testing.**

## Deploying to Cloud Foundry

### Manual staging

**Please avoid using `cf push` directly and accidentally deploying to production.**

Instead, use:

```
cf install-plugin -r CF-Community autopilot
./bin/cf-push-staging
```

This will generate the assets (Rails' asset pipeline), and then use the `cf zero-downtime-push` command (`autopilot` plugin) to deploy the application from your local terminal. The `cf zero-downtime-push` command is the same on used in the CI pipeline to push to production.

Ensure that the two `manifest*.yml` are kept in sync before deploying to production:

```
manifest-staging.yml
manifest.yml
```

### Production

**Please only deploy to production via the pipeline.**

https://ci.starkandwayne.com/teams/main/pipelines/dingo-standalone-hub

See `ci/pipeline.yml` for required environment variables.
