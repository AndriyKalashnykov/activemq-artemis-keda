#!/bin/bash
# set -x

LAUNCH_DIR=$(pwd); SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; cd $SCRIPT_DIR; cd ..; SCRIPT_PARENT_DIR=$(pwd);

. $SCRIPT_DIR/env.sh

echo "waiting for ActiveMQ service to get External-IP"
until kubectl get service/artemis -n ${DEMO_NS} --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done
export LB_IP=$(kubectl get svc/artemis -n ${DEMO_NS} -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

#curl -X POST -H "Content-Type: application/json" -d  '{ "type": "EXEC", "mbean": "org.apache.activemq.artemis:address=\"test.performance.queue\",broker=\"keda-demo-broker\",component=addresses,queue=\"test.performance.queue\",routing-type=\"anycast\",subcomponent=queues", "operation": "removeMessages(java.lang.String)", "arguments": [ "" ] }' http://192.168.200.2:8161/jolokia/exec | jq .

#curl -X  http://artemis:artemis@{LB_IP}:8161/console/jolokia/read/org.apache.activemq.artemis:broker="0.0.0.0"/Version.
#
curl -X POST --data "{\"type\":\"exec\",\
\"mbean\":\
\"org.apache.activemq.artemis:broker=\\\"keda-demo-broker\\\",component=addresses,address=\\\"ALEX.HONKING\\\",subcomponent=queues,routing-type=\\\"anycast\\\",queue=\\\"ALEX.HONKING\\\"\",\
\"operation\":\
\"sendMessage(java.util.Map,int,java.lang.String,boolean,java.lang.String,java.lang.String)\",\
\"arguments\":\
[null,3,\"HELLO ALEX\",false,\"quarkus\",\"quarkus\"]}" http://artemis:artemis@${LB_IP}:8161/console/jolokia/