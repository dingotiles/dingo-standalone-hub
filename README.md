# Webapp/API for Dingo PostgreSQL-aaS

**PRIVATE: This is our PostgreSQL Backups & HA orchestration as a Service product. See dingo-postgresql-agent for the OSS client, which includes a `test-api` for testing the agent. This repo shares some structs with agent code.**

All Dingo PostgreSQL agent nodes connect first to this API to request credentials & configuration.

Users can manage all their clusters via a web UI.


```
docker-compose up --build
```

**NOTE: `dingo-api` image is not a public image and should only be created for purposes of dev/testing.**

### Deploying to Cloud Foundry

```
cf push --random-route --no-start
cf set-env dingo-api ETCD_HOST_PORT ${ETCD_HOST_PORT:?required}
cf set-env dingo-api AWS_ACCESS_KEY_ID ${AWS_ACCESS_KEY_ID:?required}
cf set-env dingo-api AWS_SECRET_ACCESS_KEY ${AWS_SECRET_ACCESS_KEY:?required}
cf set-env dingo-api WAL_S3_BUCKET ${WAL_S3_BUCKET:?required}
cf set-env dingo-api WALE_S3_ENDPOINT ${WALE_S3_ENDPOINT:?required}
cf start
```

## Development

Static assets - like the text for tutorial terminal windows - is stored in `data/` directory, and is embedded in the golang application within `bindata.go`.

Anytime `data/` contents are changed, regenerate `bindata.go` using:

```
go get -u github.com/jteeuwen/go-bindata/...
go-bindata data/...
```

To run the local tests:

```
go test $(go list ./... | grep -v /vendor/)
```
