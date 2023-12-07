#!/bin/bash

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
