# Kubernetes Homelab

## Overview

This repository contains the Kubernetes and Talos configuration for the homelab cluster. Applications are deployed with Argo CD and secrets are managed with Sealed Secrets.

## Agent-safe workflow

Agents may prepare and validate repository changes, but must not apply Kubernetes or Talos changes, upgrade Talos, sync Argo CD, or use live-cluster credentials. Use `AGENTS.md` and the path-specific instructions under `.github/instructions/` for the complete workflow.

Agents must never receive credentials or run `kubeseal`. They may prepare `SealedSecret` structure, placeholders, and handoff notes. A human operator must enter credentials and perform the final sealing outside the devcontainer. `talos/devsecrets.yaml` is synthetic development material only.

## Talos machine configurations

Machine configurations are generated from the patches in `talos/patches/` and the node-specific files in `talos/nodes/`. Use the repository scripts rather than running `talosctl gen config` manually.

The scripts require PowerShell 7, `kubectl`, and `talosctl`. The current `kubectl` context must point to the cluster for normal operation. If the `powershell-yaml` module is missing, the scripts install it for the current user.

### Generate a configuration

Generate a configuration for one node:

```powershell
pwsh -File ./talos/scripts/generate-machineconfig.ps1 -NodeName njord-1-cp1
```

The generated file is written to `talos/rendered/<NodeName>.yaml`. Pass `-NodeType controlplane` or `-NodeType worker` when the type cannot be inferred from the cluster.

To generate configurations for every node, use `ALL`:

```powershell
pwsh -File ./talos/scripts/generate-machineconfig.ps1 -NodeName ALL
```

### Apply a configuration

The following is a human-operated procedure. Agents must not run it.

Add `-Apply` to generate and apply the configuration:

```powershell
pwsh -File ./talos/scripts/generate-machineconfig.ps1 -NodeName njord-1-cp1 -Apply
```

For a node that is not yet part of the cluster, provide its initial IP and use `-Init`:

```powershell
pwsh -File ./talos/scripts/generate-machineconfig.ps1 `
  -NodeName njord-1-cp1 `
  -Init `
  -InitialNodeIp 10.0.10.111 `
  -Apply
```

Use `-Dev` to render a configuration to standard output with the development secrets. It does not apply configurations.

## Upgrade Talos

The following is a human-operated procedure. Agents must not run it.

Use the upgrade script for one node or every node. Without `-UpdateImage`, it derives the image from each node's Talos schematic annotation.

```powershell
pwsh -File ./talos/scripts/update-talos.ps1 -NodeName njord-1-cp1 -Version <target-version>
pwsh -File ./talos/scripts/update-talos.ps1 -NodeName ALL -Version <target-version>
```

To use a specific image, pass `-UpdateImage`:

```powershell
pwsh -File ./talos/scripts/update-talos.ps1 `
  -NodeName njord-1-cp1 `
  -Version <target-version> `
  -UpdateImage factory.talos.dev/metal-installer/<schematic>:v<target-version>
```
