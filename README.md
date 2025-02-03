
<h1 align="center">
  <a href="https://github.com/ansible-rke2-rancher">
    <img src="https://miro.medium.com/v2/resize:fit:860/1*1ksTBYe_OBpsVd7eHGjLnA.jpeg" alt="Logo" width="" height="">
  </a>
</h1>

<div align="center">
  <b>ansible-rke2-rancher</b> - Setup a RKE2 Cluster with Rancher UI and letsencrypt in minutes.
  <br />
  <br />
  <a href="https://github.com/ansible-rke2-rancher/issues/new?assignees=&labels=bug&title=bug%3A+">Report a Bug</a>
  ·
  <a href="https://github.com/ansible-rke2-rancher/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>
</div>
<br>
<details open="open">
<summary>Table of Contents</summary>

- [About](#about)
- [Repository Structure](#repository-structure)
- [Install Required Ansible Collections](#install-required-ansible-collections)
- [Usage](#usage)
  - [Inventory Configuration](#inventory-configuration)
  - [Variable Configuration](#variable-configuration)
  - [Running the Playbook](#running-the-playbook)
- [Contributing](#contributing)
- [License](#license)

</details>
<br>

---

## Repository Structure

```plaintext
├── inventory/
│   ├── hosts.ini
│   └── group_vars/
│       └── all.yml
├── playbook.yml
├── requirements.yml
├── secrets.yaml
├── roles/
│   ├── common/
│   │   └── tasks/
│   │       └── apt.yml
|   |       └── debug.yml
|   |       └── main.yml
|   |       └── ufw.yml
|   |       └── ssh_setup.yml
│   ├── helm/
│   │   ├── tasks/
│   │       └── main.yml
│   ├── helm_plugins/
│   │   └── tasks/
│   │       └── main.yml
│   ├── rancher/
│   │   ├── tasks/
│   │       └── main.yml
│   │   └── templates/
│   │       ├── values.yaml.j2
│   │       └── certificate-wildcard-spaceterran-rancher.yaml.j2
```

> **Note**  
> :yellow_circle: **Before setting up Rancher, you will need to create a DNS A record for the domain you want to use and point it to your server.**  
> Follow the instructions [here](https://developers.cloudflare.com/dns/manage-dns-records/how-to/create-dns-records/) to create the required DNS A record.



### Install Required Ansible Collections

Before running the playbooks, you need to install the required Ansible collections. You can do this by running:

```bash
ansible-galaxy collection install -r requirements.yml
```

## Usage

### Inventory Configuration

Update your `hosts.ini` file with the target servers and any required variables:

**inventory/hosts.ini:**

```ini
[rke2_server_agents]
server_agent_1 ansible_host=192.168.0.26
server_agent_2 ansible_host=192.168.0.29
server_agent_3 ansible_host=192.168.0.24

[rke2_worker_agents]
worker_agent_1 ansible_host=192.168.0.27

[rke2_server_agents:vars]
ansible_user={{ssh_user}} 
ansible_port={{ssh_port}}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_ssh_private_key_file={{ssh_cert}}
ansible_become=true

[rke2_worker_agents:vars]
ansible_user={{ssh_user}}
ansible_port={{ssh_port}}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_ssh_private_key_file={{ssh_cert}}
ansible_become=true

```

### Variable Configuration

Update the centralized variables in `inventory/group_vars/all.yml`:

**inventory/group_vars/all.yml:**

```yaml
---
# Ansible Common Variables
---
# Ansible Common Variables
home_path: /home/adminuser
ssh_user: adminuser
ansible_sudo_pass: adminpass
ssh_cert: ~/.ssh/id_ed25519
ssh_port: "22"
TZ: America/Toronto

# Kubernetes
kubectl_config: "/etc/rancher/rke2/rke2.yaml"
helm_version: v3.15.1 # https://github.com/helm/helm/releases

# cert-manager
cert_manager_chart_ref: jetstack/cert-manager
cert_manager_chart_version: v1.15.0 # https://github.com/cert-manager/cert-manager/releases
cert_manager_email: "your-email@gmail.com"

# Rancher
rancher_chart_ref: rancher-stable/rancher
rancher_chart_version: v2.10.2 # https://github.com/rancher/rancher/releases
rancher_path: "{{ home_path }}/rancher"
hostname: "hostname@domain.com"
bootstrap_password: "your-bootstrap-password"


```

### Running the Playbook

To execute the playbook, run:

```bash
ansible-playbook -i inventory/hosts.ini playbook.yml