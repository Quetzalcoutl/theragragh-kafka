# TheraGraph Kafka Service

This folder contains a Docker Compose setup for running Kafka, Zookeeper, and Kafka UI on VM03 (the Rust VM).

## Setup on VM03 (IP: 168.228.7.38)

1. Clone this repo: `git clone https://github.com/Quetzalcoutl/theragragh-kafka.git`
2. Run `docker-compose up -d` to start all services.
3. Kafka will be available on:
   - Internal (for Rust app on same VM): `localhost:29092`
   - External (for indexer on other VM): `168.228.7.38:9095`
4. Kafka UI: http://localhost:8080 (on VM03) or http://168.228.7.38:8080 (from other VMs)

## Configuration

- Replace `<VM03_IP>` in `docker-compose.yml` with VM03's IP for external access.
- Open firewall on VM03 for ports 9095 (Kafka) and 8080 (UI) if needed.

## Usage

- Start: `docker-compose up -d`
- Stop: `docker-compose down`
- Logs: `docker-compose logs -f kafka`

## Environment Variables for Apps

- Rust app (on VM03): `KAFKA_BROKERS=localhost:29092`
- Indexer (on other VM): `KAFKA_BROKERS=<VM03_IP>:9095`