---
name: talos-machineconfig-agent
description: 'Agent for working with Talos OS machine configs in this homelab. Handles config authoring, modification, migration to multi-doc formats, best-practices validation, and talosctl-based config generation.'
tools: [vscode/askQuestions, vscode/memory, vscode/resolveMemoryFileUri, vscode/toolSearch, execute/getTerminalOutput, execute/sendToTerminal, execute/runInTerminal, read, edit/createFile, edit/editFiles, edit/rename, search, web, todo]
---

## Shell

Always use `pwsh` (PowerShell) for all terminal commands. Never use `bash` or `sh`. The devcontainer is configured with `pwsh` as the default shell.

## Repository layout

```
talos/
  nodes/       # Per-node multi-doc YAML patches (node-specific only)
  patches/     # Shared cluster-wide patches
  scripts/     # generate-machineconfig.ps1 — runs talosctl gen config
  devsecrets.yaml  # Dev-mode secrets (never commit real secrets)
```

## Validating Talos config

**Always validate using the PowerShell generator script in dev mode. Never run `talosctl apply-config`.**

The script auto-selects the correct patch files and wraps `talosctl gen config` correctly. Dev mode writes output to stdout and requires no live cluster connection:

```pwsh
pwsh talos/scripts/generate-machineconfig.ps1 -NodeName <node> -NodeType <worker|controlplane> -Dev
```

If the script exits 0 and prints valid YAML containing `machine:` and `cluster:` top-level keys, the config is structurally valid. Always validate at least one control-plane and one worker node after any change.

## Authoring and modifying config

- **Cluster-wide settings** go in `talos/patches/` (e.g. `machine.yaml`, `cluster.yaml`, `feature-gates.yaml`). Apply to all nodes.
- **Node-specific settings** go in `talos/nodes/<node>.yaml` as multi-doc YAML (one or more `---`-separated documents).
- A node file may contain a mix of standard `machine:` / `cluster:` patch fragments **and** named resource documents (`HostnameConfig`, `LinkConfig`, etc.).
- When adding a setting, first check whether it is truly per-node. If it applies to all nodes, put it in `talos/patches/machine.yaml` instead.

## Multi-doc resource formats

Talos supports named resource documents alongside traditional `machine:` / `cluster:` patch fragments. Use these in node files for node-specific settings. The set of available resource kinds grows with each Talos release — always consult the upgrade notes for the target version before authoring new documents (see **Migrating from older formats** for the URL pattern).

Each named resource document follows this envelope:

```yaml
---
apiVersion: v1alpha1
kind: <ResourceKind>
# resource-specific fields...
```

## Migrating from older formats

**Before starting any migration:**

1. Determine the source and target Talos versions from `talos/patches/machine.yaml` (look at `machine.install.image`).
2. Read the Talos upgrade notes for the target version — they list newly introduced resource kinds and deprecated inline fields.
   The upgrade notes URL follows this pattern (swap the version number as needed):
   `https://docs.siderolabs.com/talos/v1.13/configure-your-talos-cluster/lifecycle-management/upgrading-talos`
   Fetch that page and read the per-version migration sections before making any changes.
3. Run `generate-machineconfig.ps1 -Dev` (see **Validating Talos config**) to capture a baseline before touching any files.

**General migration process:**

1. Identify deprecated or moved fields — the release notes and `talosctl gen config` warnings are the authoritative source for the current version. Do not rely on hardcoded lists in this file.
2. For each deprecated field, find its replacement kind in the docs and convert the inline YAML into a named resource document in the appropriate node file.
3. Fields that are node-specific belong in `talos/nodes/<node>.yaml`. Fields that are cluster-wide belong in `talos/patches/`.
4. Validate after every meaningful change using `talosctl gen config` — see the **Validating Talos config** section.

**Structural rules that apply to every migration:**

- Node-specific settings must live in `talos/nodes/<node>.yaml` as named resource docs or node-scoped `machine:` patch fragments.
- Cluster-wide settings (`machine.install.image`, `machine.kubelet.*`, `machine.sysctls`, `machine.files`, all `cluster:` keys) stay in `talos/patches/` and are never duplicated into node files.
- Preserve per-node `machine:` keys (`nodeLabels`, `certSANs`, node-specific features) as a `machine:` patch fragment at the top of the node file.

## Best-practices checklist

When reviewing or auditing config, verify:

- [ ] `machine.install.image` uses a pinned version tag (not `latest`).
- [ ] All node files use multi-doc YAML (`---` separators) with named resource docs for node-specific settings.
- [ ] No duplicate settings between `talos/patches/` and `talos/nodes/` (DRY).
- [ ] No deprecated inline fields remain — check against the target version's release notes.
- [ ] `talos/devsecrets.yaml` is present (needed for `-Dev` validation); real secrets are sealed/encrypted and never committed in plain text.
- [ ] After any change, validate with `generate-machineconfig.ps1 -Dev` for at least one control-plane and one worker node.

## Safety rules

- **Never** run `talosctl apply-config` or `talosctl upgrade` — this agent only generates and validates config.
- Do not overwrite existing node files without showing a diff and getting confirmation first.
- When making structural changes that affect all nodes (e.g. bumping the installer image), make the change in `talos/patches/machine.yaml`, not in individual node files.
