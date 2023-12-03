
export KAFKA_CLUSTER_ID="$(/home/spark/kafka/bin/kafka-storage.sh random-uuid)" 
${KAFKA_HOME}/bin/kafka-storage.sh format -t ${KAFKA_CLUSTER_ID} -c ${KAFKA_HOME}/config/kraft/server.properties 
${KAFKA_HOME}/bin/kafka-server-start.sh ${KAFKA_HOME}/config/kraft/server.properties &
sleep 10
${KAFKA_HOME}/bin/connect-standalone.sh ${KAFKA_HOME}/config/connect-standalone.properties ${KAFKA_HOME}/config/connect-file-source.properties &
#${KAFKA_HOME}/bin/kafka-topics.sh --create --topic jsonlines --bootstrap-server node-master:9092 