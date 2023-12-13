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
cd camel-amqp-quarkus
mvn quarkus:dev
```

## Packaging application

Produces the `camel-amqp-quarkus-1.0.0-SNAPSHOT-runner.jar` file in the `/target` directory.
```bash
cd camel-amqp-quarkus
mvn package
```

## Creating a native executable

With GraalVM istalled 
```bash
sdk install java 17.0.9-graal
sdk use java 17.0.9-graal
cd camel-amqp-quarkus
mvn package -Pnative
```
without GraalVM installed
```bash
cd camel-amqp-quarkus
mvn package -Pnative -Dquarkus.native.container-build=true
```

## Building Docker image

```bash
cd camel-amqp-quarkus
docker build -f camel-amqp-quarkus/src/main/docker/Dockerfile.native -t andriykalashnykov/camel-amqp-quarkus .
docker push andriykalashnykov/camel-amqp-quarkus
```

## Running application

```bash
cd camel-amqp-quarkus
java -jar target/camel-amqp-quarkus-1.0.0-SNAPSHOT-runner.jar
```

## Install KEDA

```bash
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
kubectl create namespace keda
helm install keda kedacore/keda --namespace keda
```

## Install camel-amqp-quarkus demo project

Optional: load images into `minikube` or `KinD`
```bash
docker pull andriykalashnykov/camel-amqp-quarkus
minikube image load andriykalashnykov/camel-amqp-quarkus
```

```bash
kubectl create namespace keda-demo
kubectl apply -f k8s/artemis.yaml
kubectl apply -f k8s/camel-amqp-quarkus.yaml
kubectl apply -f k8s/keda-scaled-camel-amqp-quarkus.yaml
```

## Sending Messages

```bash
kubectl exec --stdin --tty -n keda-demo artemis-85b99f8fc9-6gb4g -- /bin/sh
./var/lib/artemis/bin/artemis producer --user artemis --password artemis --destination demoqueue   --message-size 1024 --message-count 10
```

## References 
* [Building native executables](https://quarkus.io/guides/building-native-image)
* [ActiveMQ-Artemis k8 manifest 1](https://github.com/Lynch0001/activemq-artemis-tf-module/blob/main/charts/templates/deployment.yaml)
* [ActiveMQ-Artemis k8 manifest 2](https://github.com/openslice/io.openslice.main/blob/master/kubernetes/template/artemis.yaml)
* [Artemis MQ as Docker Image](https://www.mastertheboss.com/jboss-frameworks/activemq/how-to-run-artemis-mq-as-docker-image/)
* [Running Apache ArtemisMq in Docker Desktop/Reverse Proxy to avid CORS restrictions](https://devpress.csdn.net/cloudnative/62f520e0c6770329307fb758.html)