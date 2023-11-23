---
title: "Docker Go-Kafka implementation"
date: 2023-10-09T16:52:34-06:00
tags: ["Development","Go","fast","DataEnginners"]
categories: ["Development","eng"]
draft: False
---


Prerequisites
-------------

Before diving into Go and Kafka integration, ensure you have the following tools installed on your system:

-   [Go](https://golang.org/dl/)
-   [Docker](https://www.docker.com/get-started)
-   [Docker Compose](https://docs.docker.com/compose/install/)

Setting Up Kafka with Docker Compose
------------------------------------

To get started with Kafka, we'll use Docker Compose to create a local Kafka environment. Below is a `docker-compose.yml` file that sets up Kafka with Zookeeper and Kafdrop for monitoring:
```docker
yaml

`version: '3'
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.3.2
    container_name: zookeeper
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000

  broker:
    image: confluentinc/cp-kafka:7.3.2
    container_name: broker
    ports:
      - "9092:9092"
    depends_on:
      - zookeeper
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: 'zookeeper:2181'
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_INTERNAL:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092,PLAINTEXT_INTERNAL://broker:29092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1

  kafdrop:
    image: obsidiandynamics/kafdrop
    restart: "no"
    ports:
      - "9000:9000"
    environment:
      KAFKA_BROKERCONNECT: "broker:29092"
    depends_on:
      - broker`
```
Save this file as `docker-compose.yml` in your project directory.

Running the Kafka Environment
-----------------------------

Execute the following commands to start the Kafka environment:

`docker-compose up -d`

This will launch Zookeeper, Kafka broker, and Kafdrop.


# Integrating Go with Kafka

In this project, we'll integrate Go with Kafka using the `confluent-kafka-go` library. Let's start by setting up a Go module and installing the required library.

### Step 1: Go Module Initialization

Open a terminal and navigate to your project directory. Run the following command to initialize a Go module:

`go mod init example.com/greetings` 

### Step 2: Install `confluent-kafka-go` Library

Install the `confluent-kafka-go` library by running:

`go get github.com/confluentinc/confluent-kafka-go@v1.9.2` 

### Producer Implementation

Create a file named `producer.go` and add the following code:
```go
package main

import (
	"fmt"
	"math/rand"
	"os"
	"time"

	"github.com/confluentinc/confluent-kafka-go/kafka"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintf(os.Stderr, "Usage: %s <config-file-path>\n", os.Args[0])
		os.Exit(1)
	}

	configFile := os.Args[1]
	conf := ReadConfig(configFile)

	topic := "purchases"
	p, err := kafka.NewProducer(&conf)

	if err != nil {
		fmt.Printf("Failed to create producer: %s", err)
		os.Exit(1)
	}

	// Go-routine to handle message delivery reports and other events
	go func() {
		for e := range p.Events() {
			switch ev := e.(type) {
			case *kafka.Message:
				if ev.TopicPartition.Error != nil {
					fmt.Printf("Failed to deliver message: %v\n", ev.TopicPartition)
				} else {
					fmt.Printf("Produced event to topic %s: key = %-10s value = %s\n",
						*ev.TopicPartition.Topic, string(ev.Key), string(ev.Value))
				}
			}
		}
	}()

	users := [...]string{"eabara", "jsmith", "sgarcia", "jbernard", "htanaka", "awalther"}
	items := [...]string{"book", "alarm clock", "t-shirts", "gift card", "batteries"}

	for n := 0; n < 10; n++ {
		key := users[rand.Intn(len(users))]
		data := items[rand.Intn(len(items))]
		p.Produce(&kafka.Message{
			TopicPartition: kafka.TopicPartition{Topic: &topic, Partition: kafka.PartitionAny},
			Key:            []byte(key),
			Value:          []byte(data),
		}, nil)
	}

	// Wait for all messages to be delivered
	p.Flush(15 * 1000)
	p.Close()
}
```

### Consumer Implementation

Create a file named `consumer.go` and add the following code:
```go
package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/confluentinc/confluent-kafka-go/kafka"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintf(os.Stderr, "Usage: %s <config-file-path>\n", os.Args[0])
		os.Exit(1)
	}

	configFile := os.Args[1]
	conf := ReadConfig(configFile)
	conf["group.id"] = "kafka-go-getting-started"
	conf["auto.offset.reset"] = "earliest"

	c, err := kafka.NewConsumer(&conf)

	if err != nil {
		fmt.Printf("Failed to create consumer: %s", err)
		os.Exit(1)
	}

	topic := "purchases"
	err = c.SubscribeTopics([]string{topic}, nil)

	// Set up a channel for handling Ctrl-C, etc
	sigchan := make(chan os.Signal, 1)
	signal.Notify(sigchan, syscall.SIGINT, syscall.SIGTERM)

	// Process messages
	run := true
	for run {
		select {
		case sig := <-sigchan:
			fmt.Printf("Caught signal %v: terminating\n", sig)
			run = false
		default:
			ev, err := c.ReadMessage(100 * time.Millisecond)
			if err != nil {
				// Errors are informational and automatically handled by the consumer
				continue
			}
			fmt.Printf("Consumed event from topic %s: key = %-10s value = %s\n",
				*ev.TopicPartition.Topic, string(ev.Key), string(ev.Value))
		}
	}

	c.Close()
}
```
### Utils Implementation:
Create a file named `util.go` and add the following code:

```go
package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"github.com/confluentinc/confluent-kafka-go/kafka"
)

func ReadConfig(configFile string) kafka.ConfigMap {

	m := make(map[string]kafka.ConfigValue)

	file, err := os.Open(configFile)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to open file: %s", err)
		os.Exit(1)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if !strings.HasPrefix(line, "#") && len(line) != 0 {
			kv := strings.Split(line, "=")
			parameter := strings.TrimSpace(kv[0])
			value := strings.TrimSpace(kv[1])
			m[parameter] = value
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Printf("Failed to read file: %s", err)
		os.Exit(1)
	}

	return m

}
```

Now that we have finished creating all the code, we just need to create a file to store all the Kafka properties. For this, we will create a file named `getting-started.properties` and place the following configuration:

```properties
bootstrap.servers=localhost:9092
```
### Run the Code
Run the producer and consumer programs:

you can build the producer and consumer with the following commands:
```
go build -o out/producer util.go producer.go
go build -o out/consumer util.go consumer.go
```

and you can run the files with:


```
./out/producer getting-started.properties 
./out/consumer getting-started.properties
```