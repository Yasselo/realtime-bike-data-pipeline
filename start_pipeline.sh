#!/bin/bash

# Default values if variables are not provided
: "${KAFKA_BROKER:=kafka}"
: "${KAFKA_PORT:=9092}"
: "${ELASTICSEARCH_HOST:=elasticsearch}"
: "${ELASTICSEARCH_PORT:=9200}"

# Wait until Kafka is accessible
until nc -z -v -w30 "$KAFKA_BROKER" "$KAFKA_PORT"; do
  echo "Waiting for Kafka broker to be ready at $KAFKA_BROKER:$KAFKA_PORT..."
  sleep 5
done

# Wait until Elasticsearch is accessible
until nc -z -v -w30 "$ELASTICSEARCH_HOST" "$ELASTICSEARCH_PORT"; do
  echo "Waiting for Elasticsearch to be ready at $ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT..."
  sleep 5
done

# Start Kafka producer
echo "Starting Kafka producer..."
python3 /app/producer_get_stations.py &

# Start Kafka consumer for Elasticsearch and Kibana
echo "Starting Kafka consumer for Elasticsearch..."
spark-submit \
  --master local[*] \
  --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.2.1,org.elasticsearch:elasticsearch-spark-30_2.12:8.8.2 \
  --conf "spark.jars.packages=org.apache.spark:spark-sql-kafka-0-10_2.12:3.2.1,org.elasticsearch:elasticsearch-spark-30_2.12:8.8.2" \
  --conf "spark.kafka.bootstrap.servers=$KAFKA_BROKER:$KAFKA_PORT" \
  --conf "es.nodes=$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT" \
  /app/consumer_elastic_kibana.py | tee -a output.txt &


# Wait for all processes to complete
wait

# Notify when all processes have completed
echo "All processes have completed."
