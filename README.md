
<h1 align="center">
  <a href="https://github.com/your-repo">
    <img src="https://miro.medium.com/v2/resize:fit:860/1*1ksTBYe_OBpsVd7eHGjLnA.jpeg" alt="Logo" width="" height="">
  </a>
</h1>

<div align="center">
  <b>File Converter</b> - A versatile script to convert individual files or entire folders to the desired format.
  <br />
  <br />
  <a href="https://github.com/your-repo/issues/new?assignees=&labels=bug&title=bug%3A+">Report a Bug</a>
  ·
  <a href="https://github.com/your-repo/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>
</div>
<br>
<details open="open">
<summary>Table of Contents</summary>

- [About](#about)
- [Repository Structure](#repository-structure)
- [Install Required Ansible Collections](#install-required-ansible-collections)
- [Usage](#usage)
  - [Variable Configuration](#variable-configuration)
  - [Running the Playbook](#running-the-playbook)
- [Contributing](#contributing)
- [License](#license)

</details>
<br>

---

**ANSIBLE-RKE2-RANCHER** Setup a RKE2 Cluster with Rancher UI in minutes.

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

### Install Required Ansible Collections

Before running the playbooks, you need to install the required Ansible collections. You can do this by running:

```bash
ansible-galaxy collection install -r requirements.yml
```

## Usage

### Variable Configuration

Update the centralized variables in `inventory/group_vars/all.yml`:

**inventory/group_vars/all.yml:**

```yaml
---
# Ansible Common Variables
home_path: /home/adminuser
ssh_user: adminuser
ansible_sudo_pass: adminpass
ssh_cert: ~/.ssh/id_ed25519
ssh_port: "22"
server_agent_1: "192.168.0.26"
server_agent_2: "192.168.0.29"
server_agent_3: "192.168.0.24"
worker_agent_1: "192.168.0.27"
TZ: America/Toronto

# Kubernetes
kubectl_config: "/etc/rancher/rke2/rke2.yaml"
helm_version: v3.15.1 # https://github.com/helm/helm/releases

# Rancher
rancher_chart_ref: rancher-stable/rancher
rancher_chart_version: v2.10.2 # https://github.com/rancher/rancher/releases
rancher_path: "{{ home_path }}/rancher"
hostname: "rancher-dev.branconet.lan"
```

### Running the Playbook

To execute the playbook, run:

```bash
ansible-playbook -i inventory/hosts.ini playbook.yml