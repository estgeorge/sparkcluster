

#spark/bin/spark-class org.apache.spark.deploy.master.Master -h node-master 
export KAFKA_CLUSTER_ID="$($KAFKA_HOME/bin/kafka-storage.sh random-uuid)"
$KAFKA_HOME/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c $KAFKA_HOME/config/kraft/server.properties
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/kraft/server.properties &
#$KAFKA_HOME/bin/connect-standalone.sh $KAFKA_HOME/config/connect-standalone.properties

#bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c config/kraft/server.properties

# instalando debeziun
#mkdir ~/kafka/connect
#wget -nc https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.3.0.Final/debezium-connector-postgres-2.3.0.Final-plugin.tar.gz -P ~/kafka/connect
#tar -xzvf ~/kafka/connect/debezium-connector-postgres-2.3.0.Final-plugin.tar.gz -C ~/kafka/connect/ 
#rm ~/kafka/connect/debezium-connector-postgres-2.3.0.Final-plugin.tar.gz  

kafka-topics.sh --create --topic linhas --bootstrap-server node-master:9092 
connect-standalone.sh $KAFKA_HOME/config/connect-standalone.properties $KAFKA_HOME/config/connect-file-source.properties $KAFKA_HOME/config/connect-file-sink.properties &

