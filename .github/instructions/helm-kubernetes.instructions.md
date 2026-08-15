---
applyTo: "apps/**/*.yaml,apps/**/*.yml,apps/**/Chart.yaml,apps/**/values.yaml,apps/**/templates/**"
description: "Helm and Kubernetes workflow for this homelab repository"
---

# Helm and Kubernetes Changes

- Keep chart ownership local to the affected application or category. Inspect the nearest `Chart.yaml`, `values.yaml`, templates, and parent category chart before editing.
- Do not assume a chart can render without its dependencies. Run `helm dependency build <chart>` when dependencies are declared and are not already available locally.
- Validate a changed chart with `helm lint <chart>` and `helm template <release> <chart>` using representative values. Keep generated output temporary and do not commit it unless the repository explicitly tracks it.
- For changes to `apps/_base/` or category wiring, render the parent chart and inspect generated Argo `Application` objects, paths, namespaces, sync options, pruning, and self-healing behavior.
- Treat CRD-dependent resources as requiring inspection of the owning chart and dependency versions. Do not claim cluster compatibility from template rendering alone.
- Preserve pinned image, chart, and dependency versions. Avoid introducing `latest` tags or unbounded ranges.
