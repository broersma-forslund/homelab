param(
    [Parameter(Mandatory)][string]$NodeName,
    [string]$NodeIp = "",
    [string]$NodeType = "",
    [boolean]$Apply = $false,
    [boolean]$Insecure = $false,
    [string]$RepoPath = "/home/mobrockers/git/homelab"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

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

    if(-not $NodeIp) {
        $NodeIP =  ((kubectl get node $NodeName -o yaml | ConvertFrom-Yaml).status.addresses | Where-Object { $_.type -eq "InternalIP" } | Select-Object address).address
    }

    Write-Host "⚙️ Generating $NodeName machineconfig for $NodeIp"

    $endpoint = "https://$($NodeIp):6443"

    $genArgList = @(
        "gen", "config", "njord", $endpoint,
        "--output=$RepoPath/talos/rendered/$NodeName.yaml",
        "--output-types=$NodeType",
        "--with-examples=false",
        "--with-docs=false",
        "--with-secrets=$RepoPath/secrets.yaml",
        "--config-patch-control-plane=@$RepoPath/talos/patches/control-plane-vip.yaml",
        "--config-patch=@$RepoPath/talos/patches/cluster.yaml",
        "--config-patch=@$RepoPath/talos/patches/machine.yaml",
        "--config-patch=@$RepoPath/talos/patches/region-meijhorst.yaml",
        "--config-patch=@$RepoPath/talos/nodes/$NodeName.yaml",
        "--kubernetes-version=$kubernetesVersion"
        "--force"
    )

    &talosctl $genArgList

    return $NodeIp
}

function Write-NodeConfig ($NodeName, $NodeIp) {

    Write-Host "⚙️ Applying $NodeName machineconfig to $NodeIp"

    $applyArgList = @(
        "apply-config",
        "--talosconfig=$RepoPath/talosconfig",
        "--nodes=$NodeIp",
        "--file=$RepoPath/talos/rendered/$NodeName.yaml"
    )

    if($Insecure) {
        $applyArgList += "--insecure"
    }

    &talosctl $applyArgList
}

$kubernetesVersion = (kubectl version -o yaml | ConvertFrom-Yaml).serverVersion.gitVersion.Replace("v", "")

if($NodeName -eq "ALL") {
    $nodeNames = (kubectl get nodes -o yaml | ConvertFrom-Yaml).items.metadata.name

    foreach($nodeName in $nodeNames) {
        $nodeIp = New-NodeConfig -NodeName $NodeName -NodeType $NodeType

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
