.PHONY: help setup bootstrap harden k3s calico kong check status clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Setup git hooks (run after clone)
	git config core.hooksPath .githooks
	@echo "Git hooks configured. Claude co-author tag enforced on commits."

bootstrap: setup ## Run full bootstrap (harden + k3s + calico + kong)
	./scripts/bootstrap.sh

harden: ## Run only server hardening
	./scripts/bootstrap.sh --tags hardening

k3s: ## Install K3s only
	./scripts/bootstrap.sh --tags k3s

calico: ## Install Calico CNI only
	./scripts/bootstrap.sh --tags calico

kong: ## Install Kong API Gateway only
	./scripts/bootstrap.sh --tags kong

check: ## Dry-run the full playbook
	./scripts/bootstrap.sh --check --diff

status: ## Show cluster status
	KUBECONFIG=kubeconfig.yaml kubectl get nodes -o wide && \
	KUBECONFIG=kubeconfig.yaml kubectl get pods -A

clean: ## Remove local kubeconfig
	rm -f kubeconfig.yaml
