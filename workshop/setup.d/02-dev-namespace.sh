#!/bin/bash
set -x
set +e

REGISTRY_PASSWORD=$HARBOR_PASSWORD kp secret create registry-credentials --registry harbor.${INGRESS_DOMAIN} --registry-user admin

docker login harbor.${INGRESS_DOMAIN} -u admin -p $HARBOR_PASSWORD
