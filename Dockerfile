FROM ubuntu:22.04  

ARG USERNAME=spark
ARG PASSWORD=spark
ENV USERNAME=${USERNAME}
ENV PASSWORD=${PASSWORD}

RUN apt-get update -qq 
RUN apt-get install -qq --no-install-recommends \
    sudo vim curl wget openjdk-11-jdk-headless \
    python3.10-minimal python3-pip \
    net-tools < /dev/null > /dev/null

# Clear apt cache and lists to reduce size
RUN apt clean && rm -rf /var/lib/apt/lists/* 

# Creates user and add it to sudoers 
RUN adduser --disabled-password --gecos "" ${USERNAME}
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
RUN usermod -aG sudo ${USERNAME}
# Passwordless sudo for created user
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME}
USER ${USERNAME} 

# Set working dir
ENV MYDIR /home/${USERNAME}
WORKDIR ${MYDIR}

# instala spark
ENV SPARK_HOME "${MYDIR}/spark"
RUN wget -q -nc --no-check-certificate https://dlcdn.apache.org/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz
RUN tar -xf spark-3.5.0-bin-hadoop3.tgz
RUN rm spark-3.5.0-bin-hadoop3.tgz
RUN mv spark-3.5.0-bin-hadoop3 ${SPARK_HOME}

# instala kafka
ENV KAFKA_HOME "${MYDIR}/kafka"
RUN wget -nc https://downloads.apache.org/kafka/3.4.1/kafka_2.12-3.4.1.tgz
RUN tar -xzvf kafka_2.12-3.4.1.tgz
RUN rm kafka_2.12-3.4.1.tgz
RUN mv kafka_2.12-3.4.1 ~/kafka

# instala debezium
RUN mkdir ~/kafka/connect
RUN wget -nc https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.3.0.Final/debezium-connector-postgres-2.3.0.Final-plugin.tar.gz -P ~/kafka/connect
RUN tar -xzvf ~/kafka/connect/debezium-connector-postgres-2.3.0.Final-plugin.tar.gz -C ~/kafka/connect/ 
RUN rm ~/kafka/connect/debezium-connector-postgres-2.3.0.Final-plugin.tar.gz 
RUN echo "vazio" > ~/kafka/connect/debezium-connector-postgres/cursospark.json

RUN echo 'export PATH="$PATH:$KAFKA_HOME/bin"' >> ~/.bashrc 
RUN echo 'export PATH="$PATH:$SPARK_HOME/bin"' >> ~/.bashrc 






