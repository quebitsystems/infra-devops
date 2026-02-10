# infra-devops

Secure K3s cluster with Calico CNI and Kong API Gateway, managed via Ansible.

## Stack

| Component | Purpose |
|-----------|---------|
| K3s | Lightweight Kubernetes |
| Calico | CNI + Network Policies |
| Kong | API Gateway / Ingress |
| Ansible | Configuration Management |
| Terraform | Infrastructure (future) |

## Quick Start

```bash
# Full bootstrap
make bootstrap

# Or step-by-step
make harden
make k3s
make calico
make kong

# Check cluster
export KUBECONFIG=kubeconfig.yaml
kubectl get nodes
kubectl get pods -A
```

## Structure

```
.
├── ansible/
│   ├── inventory/        # Host definitions
│   ├── group_vars/       # Variables
│   ├── roles/
│   │   ├── hardening/    # Server security
│   │   ├── k3s/          # K3s installation
│   │   ├── calico/       # Calico CNI
│   │   └── kong/         # Kong Gateway
│   └── site.yml          # Main playbook
├── manifests/            # Extra K8s manifests
├── scripts/              # Utility scripts
├── terraform/            # IaC (future)
└── Makefile
```

## Endpoints

| Service | URL |
|---------|-----|
| K3s API | `https://<server>:6443` |
| Kong HTTP | `http://<server>:30080` |
| Kong HTTPS | `https://<server>:30443` |
