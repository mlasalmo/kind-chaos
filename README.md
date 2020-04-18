# Lab environment for Chaos Engineering testing

## Requirements

- Docker for desktop (only OSX or Windows)
- kind
- kubectl
- pip
- python3
- virtualenv or virtualenvwrapper (optional)

> NOTE: Docker for desktop users, check: https://kind.sigs.k8s.io/docs/user/quick-start/#settings-for-docker-desktop

### Install requirements

OSX:

```bash
brew install kind kubectl
```

Linux:

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

### Install chaostoolkit and extras

From the root repo directory run:

```bash
pip install -r requirements.txt
```

## How this project works

Run `make` and check all actions:

```txt
create-cluster                 Create a kind single-node cluster
create-cluster-ha              Create a kind multi-node cluster (1 control-plane, 2 workers)
destroy                        Destroy kind cluster
install-demo                   Install go-demo-8 and go-demo-8-db in standalone mode
install-demo-ha                Install go-demo-8 and repeater in HA mode
install-helm-repos             Install bitnami and stable helm repositories
install-istio                  Install istio in the current active cluster with demo profile (addons enabled: grafana, kiali, prometheus, and tracing)
install-mongodb-ha             Install mongodb with replicaset enabled (HA)
ls                             List of up & running kind clusters
proxy                          Port forward to the istio ingress gateway so we can communicate with the services in the cluster
remove-demo                    Remove go-demo-8 and go-demo-8-db services
remove-demo-ha                 Remove go-demo-8 and repeater services
remove-istio                   Remove istio from the current cluster context
remove-mongodb-ha              Remove mongodb (HA) from the current cluster context
show-dashboard-grafana         Create port forwarding to grafana service and open dashboard in default browser
show-dashboard-jaeger          Create port forwarding to jaeger service and open dashboard in default browser
show-dashboard-kiali           Create port forwarding to kiali service and open dashboard in deafult browser
show-dashboard-prometheus      Create port forwarding to prometheus service and open dashboard in default browser
```
