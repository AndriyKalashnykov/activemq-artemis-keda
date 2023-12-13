default: help

.PHONY: help
help: ## list makefile targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-37s\033[0m %s\n", $$1, $$2}'

.PHONY: deploy-artemis
deploy-artemis: ## deploy ArtemisMQ
	./scripts/deploy-artemis.sh

.PHONY: delete-artemis
delete-artemis: ## delete ArtemisMQ
	./scripts/delete-artemis.sh

.PHONY: deploy-camel-amqp-quarkus
deploy-camel-amqp-quarkus: ## deploy camel-amqp-quarkus
	./scripts/deploy-camel-amqp-quarkus.sh

.PHONY: delete-camel-amqp-quarkus
delete-camel-amqp-quarkus: ## delete camel-amqp-quarkus
	./scripts/delete-camel-amqp-quarkus.sh

.PHONY: deploy-keda-scaled-camel-amqp-quarkus
deploy-keda-scaled-camel-amqp-quarkus: ## deploy keda-scaled-camel-amqp-quarkus
	./scripts/deploy-keda-scaled-camel-amqp-quarkus.sh

.PHONY: delete-keda-scaled-camel-amqp-quarkus
delete-keda-scaled-camel-amqp-quarkus: ## delete keda-scaled-camel-amqp-quarkus
	./scripts/delete-keda-scaled-camel-amqp-quarkus.sh

.PHONY: logs-artemis
logs-artemis: ## ArtemisMQ logs
	kubectl logs -n keda-demo artemis-5559967dff-z8gtw --follow
