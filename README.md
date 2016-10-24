# Webapp/API for Dingo PostgreSQL-aaS

PRIVATE: This is our PostgreSQL Backups & HA orchestration as a Service product. See dingo-postgresql-agent for the OSS client, which includes a `test-api` for testing the agent. This repo shares some structs with agent code.

All Dingo PostgreSQL agent nodes connect first to this API to request credentials & configuration.

Users can manage all their clusters via a web UI.


```
docker-compose up --build
```
