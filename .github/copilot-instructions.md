# Kubernetes Homelab Infrastructure Repository

This repository contains Kubernetes infrastructure-as-code for a homelab running Talos Kubernetes OS. It includes Helm charts organized by category and uses ArgoCD for GitOps deployment with kubeseal for secret management.

**ALWAYS follow these instructions first and only fall back to additional search or bash commands if the information here is incomplete or found to be in error.**

## Required Tools Installation

Install these tools before working with the repository:

### Install kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

### Install Helm
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

### Install talosctl
```bash
curl -LO "https://github.com/siderolabs/talos/releases/download/v1.8.4/talosctl-linux-amd64"
chmod +x talosctl-linux-amd64
sudo mv talosctl-linux-amd64 /usr/local/bin/talosctl
```

## Repository Structure

- `apps/` - Helm charts organized by category:
  - `_base/` - Base ArgoCD application template
  - `cluster/` - Core cluster services 
  - `connectivity/` - Networking services
  - `devices/` - Hardware device operators
  - `home/` - Home automation services
  - `media/` - Media server stack
  - `monitoring/` - Observability stack
  - `security/` - Security services
  - `storage/` - Storage solutions
  - `test/` - Test applications
- `talos/` - Talos OS configuration:
  - `nodes/` - Per-node configuration files
  - `patches/` - Common configuration patches
  - `scripts/` - PowerShell automation scripts
- `udm/` - UniFi Dream Machine BGP configuration

## Validation and Testing

### Basic Repository Validation
Always run these commands to validate the repository state:

```bash
# Lint all Helm charts
helm lint apps/_base/

# Count charts and validate structure
find apps -name "Chart.yaml" | wc -l

# Validate YAML syntax across repository  
find . -name "*.yaml" -exec yamllint {} \; 2>/dev/null || echo "yamllint not available"
```

### Helm Chart Operations

For charts with dependencies, use:

```bash
# Build chart dependencies
helm dependency build apps/path/to/chart/

# Lint specific chart
helm lint apps/path/to/chart/

# Test template generation
helm template apps/path/to/chart/ --dry-run
```

If network connectivity issues occur, request that network connectivity be resolved before continuing.

### Talos Configuration

For working with Talos configuration files:

```bash
# Validate YAML syntax
yamllint talos/patches/*.yaml
yamllint talos/nodes/*.yaml

# Generate temporary configuration for validation (requires talos secrets)
talosctl gen config test-cluster https://test:6443 --with-secrets secrets.yaml --config-patch @talos/patches/cluster.yaml
```

## Common Validation Workflows

### After Making Changes to Helm Charts
1. **Always run helm lint on modified charts**:
   ```bash
   helm lint apps/path/to/modified/chart/
   ```

2. **Build dependencies if chart has dependencies**:
   ```bash
   helm dependency build apps/path/to/modified/chart/
   ```

3. **Test template generation**:
   ```bash
   helm template apps/path/to/modified/chart/ --dry-run
   ```

4. **Validate YAML structure**:
   ```bash
   find apps/path/to/chart/ -name "*.yaml" -exec yamllint {} \;
   ```

### After Modifying Talos Configuration
1. **Validate YAML syntax**:
   ```bash
   yamllint talos/patches/*.yaml
   yamllint talos/nodes/*.yaml
   ```

2. **Test configuration generation** (if talos secrets are available):
   ```bash
   talosctl gen config test-cluster https://test:6443 --with-secrets secrets.yaml --config-patch @talos/patches/cluster.yaml
   ```

## Common Commands Reference

```bash
# Repository overview
find apps -maxdepth 2 -type d | sort
find apps -name "Chart.yaml" | wc -l
find . -name "*.yaml" | wc -l

# Quick chart validation
for chart in apps/*/; do helm lint "$chart" 2>/dev/null && echo "✓ $chart"; done

# Tool version verification
kubectl version --client
helm version
talosctl version --client
```