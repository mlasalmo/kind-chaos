SHELL := /bin/bash

SHELL_SPEC_DIR ?= /var/tmp

.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: create-cluster
create-cluster: ## Create a kind single-node cluster
	@kind create cluster

.PHONY: create-multinode-cluster
create-multinode-cluster: ## Create a kind multi-node cluster (1 control-plane, 2 workers)
	@kind create cluster --config conf.d/multinode.yml
	@kubectl apply -f conf.d/calico.yml

.PHONY: destroy
destroy: ## Destroy kind cluster
	@kind delete cluster

.PHONY: install-istio
install-istio: ## Install istio in the current active cluster with demo profile (addons enabled: grafana, kiali, prometheus, and tracing)
	@istioctl manifest apply --set profile=demo

.PHONY: ls
ls: ## List up & running kind clusters
	@kind get clusters

.PHONY: remove-istio
remove-istio: ## Removes istio from the current active cluster
	@istioctl manifest generate --set profile=demo | kubectl delete -f -

.PHONY: show-dashboard-grafana
show-dashboard-grafana: ## Create port forwarding to grafana service and open dashboard in default browser
	@istioctl dashboard grafana

.PHONY: show-dashboard-jaeger
show-dashboard-jaeger: ## Create port forwarding to jaeger service and open dashboard in default browser
	@istioctl dashboard jaeger

.PHONY: show-dashboard-kiali
show-dashboard-kiali: ## Create port forwarding to kiali service and open dashboard in deafult browser
	@istioctl dashboard kiali

.PHONY: show-dashboard-prometheus
show-dashboard-prometheus: ## Create port forwarding to prometheus service and open dashboard in default browser
	@istioctl dashboard prometheus
