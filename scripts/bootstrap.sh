#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================="
echo "  K3s Cluster Bootstrap"
echo "  Calico CNI + Kong API Gateway"
echo "========================================="

# Check dependencies
for cmd in ansible-playbook ssh; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "ERROR: $cmd is not installed."
    exit 1
  fi
done

# Parse arguments
TAGS=""
SKIP_TAGS=""
EXTRA_ARGS=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --tags)       TAGS="--tags $2"; shift 2 ;;
    --skip-tags)  SKIP_TAGS="--skip-tags $2"; shift 2 ;;
    --check)      EXTRA_ARGS="$EXTRA_ARGS --check"; shift ;;
    --diff)       EXTRA_ARGS="$EXTRA_ARGS --diff"; shift ;;
    *)            EXTRA_ARGS="$EXTRA_ARGS $1"; shift ;;
  esac
done

echo ""
echo "Running Ansible playbook..."
echo ""

cd "$PROJECT_DIR/ansible"

ansible-playbook site.yml \
  -i inventory/hosts.ini \
  $TAGS \
  $SKIP_TAGS \
  $EXTRA_ARGS

echo ""
echo "Bootstrap complete!"
echo "Kubeconfig saved to: $PROJECT_DIR/kubeconfig.yaml"
echo ""
echo "To use: export KUBECONFIG=$PROJECT_DIR/kubeconfig.yaml"
