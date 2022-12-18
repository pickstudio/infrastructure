#!/bin/bash

# turn on bash's job control
set -m

# Start the helper process
/bin/prometheus-ecs-discovery -config.write-to=${CONFIG_DISCOVERY_YAML}&

# Start the primary process and put it in the background
/bin/agent \
  -enable-features=integrations-next \
  -config.file=/etc/agent/agent.yaml \
  -config.enable-read-api \
  -config.expand-env
