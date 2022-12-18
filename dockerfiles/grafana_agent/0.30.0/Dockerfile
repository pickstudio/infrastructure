FROM 755991664675.dkr.ecr.ap-northeast-2.amazonaws.com/infrastructure/prometheus-ecs-discovery:latest AS DISCOVERY
FROM grafana/agent:v0.30.0-rc.0 AS AGENT
COPY --from=DISCOVERY /bin/prometheus-ecs-discovery /bin/

WORKDIR /etc/agent

COPY ./agent.yaml /etc/agent/agent.yaml
COPY ./entrypoint.sh ./entrypoint.sh

ENTRYPOINT /etc/agent/entrypoint.sh