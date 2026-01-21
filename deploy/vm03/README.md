VM03 deployment instructions

1) Edit `deploy/vm03/docker-compose.yml` to set IPs/ports as needed (values are inlined by default).
2) On VM03 ensure docker and docker-compose (docker compose plugin) are installed and Docker daemon running.
3) Create the external network if it does not exist:
   - `docker network create theragraph-net`
4) From the `theragraph-kafka` repo root on the VM run:
   - `cd deploy/vm03`
   - `chmod +x deploy.sh`
   - `./deploy.sh`
5) Verify:
   - `docker compose ps`
   - `docker compose logs -f kafka`
   - Kafka UI: `http://<VM03_IP>:8081`
   - Engine: `http://<VM03_IP>:8081/health`

Optional: systemd service to start stack on boot

Create `/etc/systemd/system/theragraph-stack.service` with:

[Unit]
Description=TheraGraph VM03 Stack
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/path/to/repo/theragraph-kafka/deploy/vm03
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down

[Install]
WantedBy=multi-user.target

Enable and start:
  - `sudo systemctl daemon-reload`
  - `sudo systemctl enable --now theragraph-stack.service`

Security notes
- Open TCP ports: 9095 (external kafka if needed), 8081 (engine and/or kafka-ui), and 2181 (ZK) only as required; prefer internal-only access.
- In production use TLS + SASL for Kafka or put Kafka in a private network with restricted ingress.