# Webapp/API for Dinog PostgreSQL aaS

PRIVATE: This is our PostgreSQL Backups & HA orchestration as a Service product.

All Dingo PostgreSQL nodes connect first to this API to request credentials & configuration.

Users can manage all their clusters via a web UI.

## Local

To run this API from source, either:

```
go run main.go
gin main.go
```

To run this API and an agent (which is configured to connect to the local API):

```
goreman start
```
