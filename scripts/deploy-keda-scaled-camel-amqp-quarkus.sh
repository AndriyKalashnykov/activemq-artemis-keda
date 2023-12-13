#!/bin/bash
# set -x

LAUNCH_DIR=$(pwd); SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; cd $SCRIPT_DIR; cd ..; SCRIPT_PARENT_DIR=$(pwd);

. $SCRIPT_DIR/env.sh

kubectl create namespace ${DEMO_NS} --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n ${DEMO_NS} -f $SCRIPT_PARENT_DIR/k8s/keda-scaled-camel-amqp-quarkus.yaml