# Lab environment for Chaos Engineering testing

## Requirements

- Docker for desktop (only OSX or Windows)
- kind
- kubectl

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

## How this project works

Run `make` and check all actions:

```txt
create-cluster                 Create a kind single-node cluster
create-multinode-cluster       Create a kind multi-node cluster (1 control-plane, 2 workers)
destroy                        Destroy kind cluster
install-istio                  Install istio in the current active cluster with demo profile (addons enabled: grafana, kiali, prometheus, and tracing)
ls                             List kind clusters (up & running)
remove-istio                   Removes istio from the current active cluster
show-dashboard-grafana         Create port forwarding to grafana service and open dashboard in default browser
show-dashboard-kiali           Create port forwarding to kiali service and open dashboard in deafult browser
show-dashboard-prometheus      Create port forwarding to prometheus service and open dashboard in default browser
```