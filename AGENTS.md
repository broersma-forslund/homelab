# Agent Workflow

This repository is Kubernetes and Talos infrastructure for a homelab. Applications are Helm charts deployed through Argo CD; Talos machine configurations are generated from shared and node-specific patches.

## Repository Structure

- `apps/` - Helm charts organized by category:
	- `_base/` - Base Argo CD application template
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

## Default Scope

- Work locally in the repository and keep changes narrowly scoped.
- Render, lint, inspect, and validate changes only.
- Never apply Kubernetes or Talos changes, upgrade Talos, sync Argo CD, or access a live cluster unless the human operator explicitly takes over that operation.
- Do not create or modify generated output under `talos/rendered/`.
- Preserve existing user changes and do not rewrite unrelated files.

## Secrets

- Never request, inspect, copy, log, or invent real credentials.
- Never use or install `kubeseal`, sealing certificates, kubeconfigs, or other credential-bearing tooling in the agent environment.
- Agents may prepare `SealedSecret` structure, placeholders, and documentation. Final sealing and credential entry are a human-only handoff performed outside the devcontainer.
- `talos/devsecrets.yaml` is synthetic development material only. Never replace it with real secrets.

## Validation

Choose the narrowest applicable check and report what was run:

- Helm changes: build dependencies if needed, run `helm lint`, then render with `helm template`.
- Talos changes: use `pwsh talos/scripts/generate-machineconfig.ps1 ... -Dev` for at least one control-plane and one worker configuration.
- Shared Argo or category wiring: render the affected parent chart and inspect application paths, namespaces, sync settings, and prune behavior.
- If a check cannot run because it needs cluster access or credentials, stop at the safe local check and state the limitation.

## High-Risk Areas

Review carefully before changing:

- `apps/_base/templates/` because Argo applications default to automated sync, pruning, and self-healing.
- `talos/patches/` because shared patches affect every node.
- `talos/scripts/` because some scripts document human-operated mutation paths.
- Any file containing `kind: Secret`, sealed values, credentials, or secret references.
