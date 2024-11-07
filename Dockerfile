# Base image with OpenJDK 11
FROM openjdk:11-slim

# Install Python 3.8 and other necessary tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 python3-pip curl wget netcat && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
# Install Python 3.8, netcat, and other necessary tools

# Set environment variables
ENV JAVA_HOME=/usr/local/openjdk-11 \
    SPARK_VERSION=3.2.1 \
    SPARK_HOME=/opt/spark \
    PATH="/usr/local/openjdk-11/bin:/opt/spark/bin:$PATH"

# Install Spark
RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.2.tgz && \
    tar -xzf spark-$SPARK_VERSION-bin-hadoop3.2.tgz -C /opt && \
    mv /opt/spark-$SPARK_VERSION-bin-hadoop3.2 /opt/spark && \
    rm spark-$SPARK_VERSION-bin-hadoop3.2.tgz

# Download Kafka and Elasticsearch JARs
# Download Kafka and Elasticsearch JARs
RUN curl -o /opt/spark/jars/spark-sql-kafka-0-10_2.12-3.2.1.jar \
    https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.2.1/spark-sql-kafka-0-10_2.12-3.2.1.jar && \
    curl -o /opt/spark/jars/kafka-clients-2.8.0.jar \
    https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/2.8.0/kafka-clients-2.8.0.jar && \
    curl -o /opt/spark/jars/elasticsearch-spark-30_2.12-8.8.2.jar \
    https://repo1.maven.org/maven2/org/elasticsearch/elasticsearch-spark-30_2.12/8.8.2/elasticsearch-spark-30_2.12-8.8.2.jar \
    curl -o /opt/spark/jars/spark-streaming-kafka-0-10_2.12-3.2.1.jar \
        https://repo1.maven.org/maven2/org/apache/spark/spark-streaming-kafka-0-10_2.12/3.2.1/spark-streaming-kafka-0-10_2.12-3.2.1.jar


# Set the working directory
WORKDIR /app

# Copy the project files
COPY . /app

# Install Python dependencies
RUN pip3 install -r requirements.txt

# Define entry point with exec for proper process handling
CMD ["bash"]
