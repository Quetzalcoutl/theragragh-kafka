Production notes & quick steps

Overview
- Recommended: use a managed Kafka (Confluent Cloud / Aiven) in production for availability and security.
- If self-hosting, prefer a multi-broker cluster with proper replication and TLS/SASL. The provided `docker-compose.prod.yml` is a single-broker starter that can be used in small-production or staging; it is NOT a full HA cluster.

Quick start (self-hosted single-broker staging)
1. Populate secrets in your environment manager (Coolify) or create a local `.env.prod` (DO NOT COMMIT).
2. Start stack (from `theragraph-kafka`):
   - `cd theragraph-kafka` 
   - `EXTERNAL_HOST_PORT=19095 docker compose -f docker-compose.prod.yml --env-file .env.prod up -d`
3. Create topics using the helper script:
   - `./scripts/create-topic.sh my.topic 3 1`

Coolify / Production hints
- Deploy Kafka as its own app in Coolify or use a managed Kafka provider.
- Keep `KAFKA_AUTO_CREATE_TOPICS=false` in production and create topics explicitly (script included).
- Store `EXTERNAL_HOST_IP` and any credentials in Coolify env/secrets (do not store secrets in repo).
- Configure the Rust engine app in Coolify to use the internal bootstrap address if in the same project network (e.g., `kafka:29092`) or the managed Kafka bootstrap server if using an external provider.

Security & Ops
- Enable TLS/SASL for production Kafka (or run Kafka in a private network + restrict access via firewall).
- Monitor broker metrics (Prometheus + Grafana) and set alerts for under-replicated partitions, consumer lag, and broker health.
- Back up / snapshot broker data. Prefer multi-broker clusters for resilience.

Support
- If you'd like, I can add a `docker-compose.cluster.yml` (3 brokers + 3 zookeepers) as a more complete starting point for HA self-hosting, or draft a Coolify-specific deployment doc with exact env keys and CI steps.