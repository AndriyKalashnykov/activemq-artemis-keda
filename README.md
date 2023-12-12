# activemq-artemis-keda

This is a demo of using Apache Camel to consume messages from an AMQP (e.g. ActiveMQ Artemis) address, using Quarkus as the runtime.
This demo accompanies my blog post on event-driven integration with KEDA.

## Requirements

### ActiveMQ Artemis

```bash
curl -o apache-artemis-2.31.2-bin.tar.gz ~/Downloads/ https://dlcdn.apache.org/activemq/activemq-artemis/2.31.2/apache-artemis-2.31.2-bin.tar.gz
cd ~/Downloads/
tar -xvzf apache-artemis-2.31.2-bin.tar.gz
cd ~/Downloads/apache-artemis-2.31.2
bin/artemis create myartemis --user admin --password admin --queues queueDemo --require-login
./myartemis/bin/artemis run
```

## Running the application in dev mode

You can run the application in dev mode that enables live coding using:
```
mvn quarkus:dev
```

## Packaging application

Produces the `camel-amqp-quarkus-1.0.0-SNAPSHOT-runner.jar` file in the `/target` directory.
```bash
mvn package
```

## Creating a native executable

```bash
mvn package -Pnative
```

With GraalVM installed 
```bash
mvn package -Pnative -Dquarkus.native.container-build=true
```
## Running application

```bash
java -jar target/camel-amqp-quarkus-1.0.0-SNAPSHOT-runner.jar
```

## References 
* [Building native executables](https://quarkus.io/guides/building-native-image)
