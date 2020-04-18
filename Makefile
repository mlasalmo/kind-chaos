SHELL_SPEC_DIR ?= /var/tmp

.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: add-helm-repos
add-helm-repos: ## Add bitnami and stable helm repository if not already installed
	@helm repo list | grep bitnami || helm repo add bitnami https://charts.bitnami.com/bitnami
	@helm repo list | grep stable || helm repo add stable https://kubernetes-charts.storage.googleapis.com

.PHONY: create-cluster
create-cluster: add-helm-repos ## Create a kind single-node cluster
	@kind create cluster || true
	@helm install metrics-server stable/metrics-server \
		--atomic \
		--namespace kube-system \
		--values conf.d/metrics-server.yml
	@kubectl create namespace chaos-lab || true
	@kubectl config set-context --current --namespace=chaos-lab

.PHONY: create-cluster-ha add-helm-repos
create-cluster-ha: add-helm-repos ## Create a kind multi-node cluster (1 control-plane, 2 workers)
	@kind create cluster --config conf.d/multi-node.yml || true
	@kubectl apply -f conf.d/calico.yml
	@helm install metrics-server stable/metrics-server \
		--atomic \
		--namespace kube-system \
		--values conf.d/metrics-server.yml
	@kubectl create namespace chaos-lab || true
	@kubectl label namespace chaos-lab istio-injection=enabled
	@kubectl config set-context --current --namespace=chaos-lab

.PHONY: destroy
destroy: ## Destroy kind cluster
	@kind delete cluster

.PHONY: install-demo
install-demo: ## Install go-demo-8 and go-demo-8-db in standalone mode
	@kubectl apply --filename k8s-manifests/stack-standalone/ --namespace chaos-lab --recursive

.PHONY: install-demo-ha
install-demo-ha: ## Install go-demo-8 and repeater in HA mode
	@kubectl apply --filename k8s-manifests/stack-ha/app/ --namespace chaos-lab
	@kubectl apply --filename k8s-manifests/stack-ha/repeater/ --namespace chaos-lab


.PHONY: install-istio
install-istio: ## Install istio in the current active cluster with demo profile (addons enabled: grafana, kiali, prometheus, and tracing)
	@istioctl manifest apply --set profile=demo

.PHONY: install-mongodb-ha
install-mongodb-ha: ## Install mongodb with replicaset enabled (HA)
	@kubectl create namespace chaos-db-lab || true
	@helm install go-demo-8-db bitnami/mongodb \
		--namespace chaos-db-lab \
		--values k8s-manifests/stack-ha/db/values.yml

.PHONY: ls
ls: ## List of up & running kind clusters
	@kind get clusters

.PHONY: proxy
proxy: ## Port forward to the istio ingress gateway so we can communicate with the services in the cluster
	@kubectl port-forward svc/istio-ingressgateway 8420:80 --namespace istio-system

.PHONY: remove-demo
remove-demo: ## Remove go-demo-8 and go-demo-8-db services
	@kubectl delete --filename k8s-manifests/stack-standalone/ --namespace chaos-lab --recursive

.PHONY: remove-demo-ha
remove-demo-ha: ## Remove go-demo-8 and repeater services
	@kubectl delete --filename k8s-manifests/stack-ha/app/ --namespace chaos-lab
	@kubectl delete --filename k8s-manifests/stack-ha/repeater/ --namespace chaos-lab

.PHONY: remove-istio
remove-istio: ## Remove istio from the current cluster context
	@istioctl manifest generate --set profile=demo | kubectl delete -f -

.PHONY: remove-mongodb-ha
remove-mongodb-ha: ## Remove mongodb (HA) from the current cluster context
	@helm delete go-demo-8-db --namespace chaos-db-lab

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
