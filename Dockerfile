FROM ubuntu:22.04  

ARG USERNAME=spark
ARG PASSWORD=spark
ENV USERNAME=${USERNAME}
ENV PASSWORD=${PASSWORD}

RUN apt-get update -qq 
RUN apt-get install -qq --no-install-recommends \
    sudo wget openjdk-11-jdk-headless postgresql-client \
    python3.10-minimal python3-pip < /dev/null > /dev/null
RUN sudo pip install requests

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
ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8081
RUN wget -q -nc --no-check-certificate https://dlcdn.apache.org/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz
RUN tar -xf spark-3.5.0-bin-hadoop3.tgz
RUN rm spark-3.5.0-bin-hadoop3.tgz
RUN mv spark-3.5.0-bin-hadoop3 ${SPARK_HOME}

# instala drive jdbc.postgresql
RUN wget https://jdbc.postgresql.org/download/postgresql-42.6.0.jar
RUN mv postgresql-42.6.0.jar ${MYDIR}/spark/jars

# instala kafka
ENV KAFKA_HOME "${MYDIR}/kafka"
RUN wget -nc https://downloads.apache.org/kafka/3.4.1/kafka_2.12-3.4.1.tgz
RUN tar -xzvf kafka_2.12-3.4.1.tgz
RUN rm kafka_2.12-3.4.1.tgz
RUN mv kafka_2.12-3.4.1 ${KAFKA_HOME} 

# instala debezium
RUN mkdir ${KAFKA_HOME}/connect
RUN wget -nc https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.3.0.Final/debezium-connector-postgres-2.3.0.Final-plugin.tar.gz -P ${KAFKA_HOME}/connect
RUN tar -xzvf ${KAFKA_HOME}/connect/debezium-connector-postgres-2.3.0.Final-plugin.tar.gz -C ${KAFKA_HOME}/connect/ 
RUN rm ${KAFKA_HOME}/connect/debezium-connector-postgres-2.3.0.Final-plugin.tar.gz 

RUN echo 'export PATH="$PATH:$KAFKA_HOME/bin"' >> ~/.bashrc 
RUN echo 'export PATH="$PATH:$SPARK_HOME/bin"' >> ~/.bashrc 


