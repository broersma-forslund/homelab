---
applyTo: '**'
description: 'Repository context for GitHub Copilot.'
---

# Kubernetes Homelab Infrastructure Repository

This repository contains Kubernetes infrastructure-as-code for a homelab running Talos Kubernetes OS. It includes Helm charts organized by category and uses ArgoCD for GitOps deployment with kubeseal for secret management.

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
