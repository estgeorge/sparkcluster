
import requests

r = requests.post(' http://node-master:8083/connectors', json={
  "name": "cursospark-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "postgres-db",
    "database.server.name": "postgres-db",
    "database.port": "5432",
    "database.user": "postgres",
    "database.password": "spark",
    "database.dbname" : "engdados",
    "plugin.name": "pgoutput",
    "topic.prefix": "temperatura",
    "table.whitelist": "tempo",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter"
  }
})

print(f"Status Code: {r.status_code}, Response: {r.json()}")


