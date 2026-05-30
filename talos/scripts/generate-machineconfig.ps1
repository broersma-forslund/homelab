param(
    [Parameter(Mandatory)]
    [string]$NodeName,
    [ValidateSet("", "worker", "controlplane")]
    [string]$NodeType = "",
    [switch]$Apply = $False,
    [switch]$Init = $False,
    [string]$InitialNodeIp = "",
    [switch]$Dev = $False
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$RepoPath = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

if(-not (Get-Module powershell-yaml -ListAvailable)) {
    Install-Module powershell-yaml -Scope CurrentUser -Force
}

function New-NodeConfig ($NodeName, $NodeType) {

    if(-not $NodeType) {
        $NodeType = "worker"

        $isControlPlane = (kubectl get node $NodeName -o yaml | ConvertFrom-Yaml).metadata.labels.contains("node-role.kubernetes.io/control-plane")

        if($isControlPlane) {
            $NodeType = "controlplane"
        }
    }

    Write-Host "⚙️ Node $NodeName is a $NodeType"

    if($Dev) {
        $nodeIp = "127.0.0.1"
    }
    else if($Init) {
        $nodeIp = $InitialNodeIp
    } else {
        $nodeIp = ((kubectl get node $NodeName -o yaml | ConvertFrom-Yaml).status.addresses | Where-Object { $_.type -eq "InternalIP" } | Select-Object address).address
    }

    Write-Host "⚙️ Generating $NodeName machineconfig for $nodeIp"

    $endpoint = "https://$($nodeIp):6443"
    $outputPath = $Dev ? "-" : "$RepoPath/talos/rendered/$NodeName.yaml"
    $secretsPath = $Dev ? "$RepoPath/talos/devsecrets.yaml" : "$HOME/.talos/secrets.yaml"

    $genArgList = @(
        "gen", "config", "njord", $endpoint,
        "--output=$outputPath",
        "--output-types=$NodeType",
        "--with-examples=false",
        "--with-docs=false",
        "--with-secrets=$secretsPath",
        "--config-patch-control-plane=@$RepoPath/talos/patches/talos-api-access.yaml",
        "--config-patch=@$RepoPath/talos/patches/cluster.yaml",
        "--config-patch=@$RepoPath/talos/patches/feature-gates.yaml",
        "--config-patch=@$RepoPath/talos/patches/machine.yaml",
        "--config-patch=@$RepoPath/talos/nodes/$NodeName.yaml",
        "--kubernetes-version=$kubernetesVersion",
        "--force"
    )

    &talosctl $genArgList

    return $nodeIp
}

function Write-NodeConfig ($NodeName, $NodeIp) {

    if($Dev) { Write-Host "⚙️ Apply is not allowed in dev mode" ; return }
    Write-Host "⚙️ Applying $NodeName machineconfig to $NodeIp"

    $applyArgList = @(
        "apply-config",
        "--nodes=$NodeIp",
        "--file=$RepoPath/talos/rendered/$NodeName.yaml"
    )

    if($Init) {
        $applyArgList += "--insecure"
    }

    &talosctl $applyArgList
}

$kubernetesVersion = $Dev ? "1.35.3" : (kubectl version -o yaml | ConvertFrom-Yaml).serverVersion.gitVersion.Replace("v", "")

if($NodeName -eq "ALL") {
    $nodeNames = (kubectl get nodes -o yaml | ConvertFrom-Yaml).items.metadata.name

    foreach($nodeName in $nodeNames) {
        $nodeIp = New-NodeConfig -NodeName $nodeName -NodeType $NodeType

        if ($Apply) {
            Write-NodeConfig -NodeName $nodeName -NodeIp $nodeIp
        }
    }
} else {
    $nodeIp = New-NodeConfig -NodeName $NodeName -NodeType $NodeType

    if ($Apply) {
        Write-NodeConfig -NodeName $NodeName -NodeIp $nodeIp
    }
}
