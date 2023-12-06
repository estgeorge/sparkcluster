#!/bin/bash

# inicia kafka e conectores
export KAFKA_CLUSTER_ID="$(/home/spark/kafka/bin/kafka-storage.sh random-uuid)" 
${KAFKA_HOME}/bin/kafka-storage.sh format -t ${KAFKA_CLUSTER_ID} -c ${KAFKA_HOME}/config/kraft/server.properties 
${KAFKA_HOME}/bin/kafka-server-start.sh ${KAFKA_HOME}/config/kraft/server.properties &
sleep 10
kafka-topics.sh --bootstrap-server node-master:9092 --create --topic jsonlines
#${KAFKA_HOME}/bin/connect-standalone.sh ${KAFKA_HOME}/config/connect-standalone.properties ${KAFKA_HOME}/config/connect-file-source.properties &
/home/spark/kafka/bin/connect-standalone.sh /home/spark/kafka/config/connect-standalone.properties /home/spark/kafka/config/connect-file-source.properties &
