package demos.camel.quarkus.amqp;

import org.apache.camel.builder.RouteBuilder;

public class QueueConsumerRoute extends RouteBuilder {

    @Override
    public void configure() throws Exception {
        // Camel JMS component detects the ConnectionFactory
        // which is created by the Qpid JMS Quarkus extension
        from("jms:queue:ALEX.BIRD")
                .log("Message received: ${body}");
    }

}
