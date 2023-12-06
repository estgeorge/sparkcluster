#!/bin/bash

# Para o topico do kafka antigo e cria um novo topico
#${KAFKA_HOME}/bin/kafka-topics.sh --bootstrap-server node-master:9092 --delete --topic jsonlines
#${KAFKA_HOME}/bin/kafka-topics.sh --bootstrap-server node-master:9092 --create --topic jsonlines


# Apaga a tabela antiga e cria uma nova tabela
psql postgres://postgres:spark@postgres-db:5432/engdados << EOF
DROP TABLE IF EXISTS tempo;
CREATE TABLE tempo (
    datetime varchar(20),
    tempmax real,
    tempmin real,
    humidity real,
    city varchar(20)
);
EOF

# Apaga o json antigo e cria um arquivo vazio
sudo rm jsonlines_source.txt
sudo touch jsonlines_source.txt
