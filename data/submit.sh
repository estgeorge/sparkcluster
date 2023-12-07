#!/bin/bash

${SPARK_HOME}/bin/spark-submit \
    --master spark://node-master:7077 \
    --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.0 --num-executors 2 --executor-cores 1 --total-executor-cores 2 ~/data/job.py
    

