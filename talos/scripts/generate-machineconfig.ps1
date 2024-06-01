param(
    [string]$repoPath = "/home/mobrockers/git/homelab",
    [boolean]$extendedConfig = $false,
    [boolean]$applyConfig = $false
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if(-not (Get-Module powershell-yaml -ListAvailable)) {
    Install-Module powershell-yaml -Scope CurrentUser -Force
}

$nodes = Get-Content "$repoPath/talos/nodes/nodes.yaml" | ConvertFrom-Yaml
$kubernetesVersion = (kubectl version -o yaml | ConvertFrom-Yaml).serverVersion.gitVersion.Replace("v", "")

$controlPlanes = $nodes.ips.controlPlanes
for ($node=0; $node -lt $controlPlanes.Count; $node++) {

    Write-Host "Generating control plane $node machineconfig"

    $nodeIp = $controlPlanes[$node]
    $endpoint = "https://$($nodeIp):6443"
    $output = $applyConfig ? "$repoPath/talos/rendered/control-plane-$node.yaml" : "-"

    $cmdArgList = @(
        "gen", "config", "talos-broersma", $endpoint,              
        "--output=$output",
        "--output-types=controlplane",
        "--with-cluster-discovery=false",
        "--with-docs=$extendedConfig",
        "--with-examples=$extendedConfig",
        "--with-secrets=$repoPath/secrets.yaml",
        "--config-patch=@$repoPath/talos/patches/cluster-name.yaml",
        "--config-patch=@$repoPath/talos/patches/cluster-endpoint.yaml",
        "--config-patch=@$repoPath/talos/patches/disable-cni-and-kube-proxy.yaml",
        "--config-patch=@$repoPath/talos/patches/enable-kubeprism.yaml",
        "--config-patch=@$repoPath/talos/patches/region-meijhorst.yaml",
        "--config-patch=@$repoPath/talos/patches/zone-embla.yaml",
        "--config-patch-control-plane=@$repoPath/talos/patches/control-plane-vip.yaml",
        "--config-patch-control-plane=@$repoPath/talos/nodes/control-plane-$node.yaml",
        "--kubernetes-version=$kubernetesVersion"
        "--force"
    )

    &talosctl $cmdArgList

    if($applyConfig) {
        $cmdArgList = @(
            "apply",
            "--talosconfig=$repoPath/talosconfig",
            "--nodes=$nodeIp",
            "--file=$repoPath/talos/rendered/control-plane-$node.yaml"
        )
        &talosctl $cmdArgList
    }
}

$intelWorkers = $nodes.ips.intelWorkers
for ($node=0; $node -lt $intelWorkers.Count; $node++) {

    Write-Host "Generating worker $node machineconfig"

    $nodeIp = $intelWorkers[$node]
    $endpoint = "https://$($nodeIp):6443"
    $output = $applyConfig ? "$repoPath/talos/rendered/worker-$node.yaml" : "-"

    $cmdArgList = @(
        "gen", "config", "talos-broersma", $endpoint,              
        "--output=$output",
        "--output-types=worker",
        "--with-cluster-discovery=false",
        "--with-docs=$extendedConfig",
        "--with-examples=$extendedConfig",
        "--with-secrets=$repoPath/secrets.yaml",
        "--config-patch=@$repoPath/talos/patches/cluster-name.yaml",
        "--config-patch=@$repoPath/talos/patches/cluster-endpoint.yaml",
        "--config-patch=@$repoPath/talos/patches/disable-cni-and-kube-proxy.yaml",
        "--config-patch=@$repoPath/talos/patches/region-meijhorst.yaml",
        "--config-patch=@$repoPath/talos/patches/zone-embla.yaml",
        "--config-patch-worker=@$repoPath/talos/nodes/worker-$node.yaml",
        "--kubernetes-version=$kubernetesVersion"
        "--force"
    )

    &talosctl $cmdArgList

    if($applyConfig) {
        $cmdArgList = @(
            "apply",
            "--talosconfig=$repoPath/talosconfig",
            "--nodes=$nodeIp",
            "--file=$repoPath/talos/rendered/worker-$node.yaml"
        )
        &talosctl $cmdArgList
    }
}

$piWorkers = $nodes.ips.piWorkers
for ($node=0; $node -lt $piWorkers.Count; $node++) {

    Write-Host "Generating worker pi $node machineconfig"

    $nodeIp = $piWorkers[$node]
    $endpoint = "https://$($nodeIp):6443"
    $output = $applyConfig ? "$repoPath/talos/rendered/worker-pi-$node.yaml" : "-"

    $cmdArgList = @(
        "gen", "config", "talos-broersma", $endpoint,              
        "--output=$output",
        "--output-types=worker",
        "--with-cluster-discovery=false",
        "--with-docs=$extendedConfig",
        "--with-examples=$extendedConfig",
        "--with-secrets=$repoPath/secrets.yaml",
        "--config-patch=@$repoPath/talos/patches/cluster-name.yaml",
        "--config-patch=@$repoPath/talos/patches/cluster-endpoint.yaml",
        "--config-patch=@$repoPath/talos/patches/disable-cni-and-kube-proxy.yaml",
        "--config-patch=@$repoPath/talos/patches/region-meijhorst.yaml",
        "--config-patch=@$repoPath/talos/patches/zone-pi.yaml",
        "--config-patch-worker=@$repoPath/talos/nodes/worker-pi-$node.yaml",
        "--kubernetes-version=$kubernetesVersion"
        "--force"
    )

    &talosctl $cmdArgList

    if($applyConfig) {
        $cmdArgList = @(
            "apply",
            "--talosconfig=$repoPath/talosconfig",
            "--nodes=$nodeIp",
            "--file=$repoPath/talos/rendered/worker-pi-$node.yaml"
        )
        &talosctl $cmdArgList
    }
}
