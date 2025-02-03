
# RANCHER SERVER FIRST MASTER SETUP (Control-pane, etcd, master)
sudo -i

```
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service
cat /etc/rancher/rke2/rke2.yaml
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
/var/lib/rancher/rke2/bin/kubectl get nodes
cat /var/lib/rancher/rke2/server/node-token
journalctl -u rke2-server -f
```
# RANCHER SERVER HA MASTER SETUP (Control-pane, etcd, master)

sudo -i

```
curl -sfL https://get.rke2.io | sh -
mkdir -p /etc/rancher/rke2/
nano /etc/rancher/rke2/config.yaml
##NANO_CONTENTS
server: https://192.168.0.23:9345
token: K10fa7d092e6bb09975d11deb9ddf5b64c4c73644363837b528b8196912027025d3::server:deea6209d2ce43d84aa8ef765e26a115
###END NANO CONTENTS
systemctl enable rke2-server.service
systemctl start rke2-server.service
```


# PROMOTE MASTERS TO ALL ROLE (workers+master+controlpane+etcd)

```
/var/lib/rancher/rke2/bin/kubectl label node <node-name> node-role.kubernetes.io/etcd=true
/var/lib/rancher/rke2/bin/kubectl label node <node-name> node-role.kubernetes.io/control-plane=true
/var/lib/rancher/rke2/bin/kubectl label node <node-name> node-role.kubernetes.io/worker=true
/var/lib/rancher/rke2/bin/kubectl label node <node-name> node-role.kubernetes.io/master=true
```

# RANCHER AGENT SETUP (worker)

```
sudo -i
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -
systemctl enable rke2-agent.service
mkdir -p /etc/rancher/rke2/
nano /etc/rancher/rke2/config.yaml
##NANO_CONTENTS
server: https://192.168.0.23:9345
token: K10fa7d092e6bb09975d11deb9ddf5b64c4c73644363837b528b8196912027025d3::server:deea6209d2ce43d84aa8ef765e26a115
###END NANO CONTENTS
systemctl start rke2-agent.service
```


# ADD RANCHER UI (ADD ROUNDOBIN DNS FIRST IN PIHOLE)

```
# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
/var/lib/rancher/rke2/bin/kubectl create namespace cattle-system 
```

```
# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true \
  --version v1.5.1
```

helm install rancher rancher-latest/rancher   --namespace cattle-system   --create-namespace   --set hostname=192.168.0.23.nip.io   --set bootstrapPassword=admin   --set ingress.tls.source=none

# Get bootstrap password for ui
/var/lib/rancher/rke2/bin/kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{ .data.bootstrapPassword|base64decode}}{{ "\n" }}'

# Extend LVM
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
df -h