# Kubernetes Homelab Infrastructure Repository

This repository contains Kubernetes infrastructure-as-code for a homelab running Talos Kubernetes OS. It includes 47 Helm charts organized across 7 categories and uses ArgoCD for GitOps deployment with kubeseal for secret management.

**ALWAYS follow these instructions first and only fall back to additional search or bash commands if the information here is incomplete or found to be in error.**

## Required Tools Installation

Install all required tools before working with this repository:

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

### Install kubeseal
```bash
curl -LO "https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.27.1/kubeseal-0.27.1-linux-amd64.tar.gz"
tar -xzf kubeseal-0.27.1-linux-amd64.tar.gz kubeseal
chmod +x kubeseal
sudo mv kubeseal /usr/local/bin/
rm kubeseal-0.27.1-linux-amd64.tar.gz
```

## Repository Structure

- `apps/` - 47 Helm charts organized by category:
  - `_base/` - Base ArgoCD application template
  - `cluster/` - Core cluster services (ArgoCD, sealed-secrets, metrics-server, etc.)
  - `connectivity/` - Networking services (Cilium, cert-manager, ingress-nginx, external-dns)
  - `devices/` - Hardware device operators (GPU drivers, node feature discovery)
  - `home/` - Home automation services (Home Assistant, Immich, Nextcloud, etc.)
  - `media/` - Media server stack (Plex, Sonarr, Radarr, etc.)
  - `monitoring/` - Observability stack (Prometheus, Grafana, Gatus)
  - `security/` - Security services (Authentik)
  - `storage/` - Storage solutions (Rook Ceph, CloudNative PostgreSQL)
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
# Lint all Helm charts - takes ~2 seconds, NEVER CANCEL
helm lint apps/_base/

# Count charts and validate structure
find apps -name "Chart.yaml" | wc -l  # Should return 47

# Validate YAML syntax across repository  
find . -name "*.yaml" -exec yamllint {} \; 2>/dev/null || echo "yamllint not available"
```

### Helm Chart Operations

**CRITICAL**: Helm operations requiring internet connectivity may fail due to firewall/network restrictions. Always include error handling:

```bash
# Test chart dependencies - may fail due to network restrictions
helm dependency build apps/monitoring/kube-prometheus-stack/
# Expected: May fail with "server misbehaving" or repository errors

# Alternative: Use offline validation
helm lint apps/monitoring/kube-prometheus-stack/
# Expected: Shows warnings about missing dependencies but validates chart structure
```

### Working with External Dependencies

Many charts have external Helm repository dependencies. When working in restricted environments:

```bash
# Add common repositories (may fail in restricted networks)
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# If these fail: Document the limitation and continue with offline validation

# Update repositories - NEVER CANCEL, can take 2-5 minutes
helm repo update
```

**TIMEOUT WARNING**: Set timeouts of 300+ seconds for `helm repo update` and `helm dependency build` operations.

## Talos Cluster Management

### Node Configuration Generation
Use PowerShell scripts for node management (requires PowerShell and cluster access):

```powershell
# Generate configuration for a single node
./talos/scripts/generate-machineconfig.ps1 -NodeName "talos-worker-1" -Apply $false

# Generate configurations for all nodes
./talos/scripts/generate-machineconfig.ps1 -NodeName "ALL" -Apply $false

# Update Talos version on nodes
./talos/scripts/update-talos.ps1 -NodeName "talos-worker-1" -Version "1.8.4"
```

### Manual Talos Operations
```bash
# Generate control plane configuration (requires cluster access)
export TALOSCONFIG=/path/to/talos/config
CONTROLPLANE=0
NODEIP=10.0.10.111
talosctl gen config talos-broersma https://$NODEIP:6443 \
    --output rendered/control-plane-$CONTROLPLANE.yaml \
    --output-types controlplane \
    --with-cluster-discovery=false \
    --with-secrets secrets.yaml \
    --config-patch @talos/patches/cluster.yaml

# Apply configuration (requires cluster access)
talosctl apply-config --nodes $NODEIP --file rendered/control-plane-$CONTROLPLANE.yaml
```

## Secret Management

### Working with Sealed Secrets
```bash
# Create sealed secret (requires cluster access with sealed-secrets controller)
echo "mysecret" | kubeseal --raw --from-file=/dev/stdin --name=test-secret --namespace=default

# Offline validation (will fail but shows command structure)
kubeseal --version  # Verify installation
```

**Note**: kubeseal operations require connection to a Kubernetes cluster with sealed-secrets controller installed.

## Common Validation Workflows

### After Making Changes to Helm Charts
1. **Always run helm lint on modified charts**:
   ```bash
   helm lint apps/path/to/modified/chart/
   ```

2. **Test template generation (may require dependencies)**:
   ```bash
   helm template apps/path/to/chart/ --dry-run
   ```

3. **Validate YAML structure**:
   ```bash
   find apps/path/to/chart/ -name "*.yaml" -exec yamllint {} \;
   # Note: May show existing style warnings - focus on syntax errors only
   ```

### After Modifying Talos Configuration
1. **Validate YAML syntax**:
   ```bash
   yamllint talos/patches/*.yaml
   yamllint talos/nodes/*.yaml
   # Note: May show existing style warnings/errors - focus on syntax errors only
   ```

2. **Test configuration generation** (requires cluster access):
   ```bash
   talosctl gen config test-cluster https://test:6443 --with-secrets secrets.yaml --config-patch @talos/patches/cluster.yaml
   ```

## Expected Timing and Timeouts

- **helm lint**: < 2 seconds per chart, < 5 seconds for all charts
- **helm dependency build**: 30-300 seconds (NEVER CANCEL - network dependent)
- **helm repo update**: 30-300 seconds (NEVER CANCEL - network dependent)  
- **talosctl gen config**: 5-30 seconds
- **Tool installations**: 10-60 seconds each

**CRITICAL**: Always set timeouts of 300+ seconds for network operations. Repository and internet connectivity issues are common.

## Network and Connectivity Limitations

This repository requires internet connectivity for:
- Helm repository access
- Helm chart dependency resolution
- Tool downloads

In restricted environments:
- Helm operations may fail with DNS/network errors
- Use offline validation methods (helm lint, yaml syntax checking)
- Document any failures as environment limitations, not code issues

## Common Commands Reference

```bash
# Repository overview
find apps -maxdepth 2 -type d | sort  # View application structure
find apps -name "Chart.yaml" | wc -l  # Count charts (should be 47)
find . -name "*.yaml" | wc -l         # Count YAML files (should be ~330)

# Quick chart validation
for chart in apps/*/; do helm lint "$chart" 2>/dev/null && echo "✓ $chart"; done

# Tool version verification
kubectl version --client
helm version
talosctl version --client  
kubeseal --version
```

## Troubleshooting

### Helm Dependency Issues
- **Problem**: `helm dependency build` fails with network errors
- **Solution**: Use `helm lint` for offline validation, document network limitations

### Missing Talos Cluster Access
- **Problem**: talosctl commands fail with connection errors
- **Solution**: Validate YAML syntax only, document cluster access requirement

### Kubeseal Requires Cluster Access
- **Problem**: kubeseal fails without cluster connection
- **Solution**: Verify installation only, document cluster requirement for actual secret creation

## VSCode Extensions

Recommended extensions (see `.vscode/extensions.json`):
- `ms-kubernetes-tools.vscode-kubernetes-tools` - Kubernetes support
- `ms-vscode-remote.remote-wsl` - Remote development support

**Always validate your changes using the commands above before committing. Focus on syntax validation and structure verification when full cluster access is not available.**