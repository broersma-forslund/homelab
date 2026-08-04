param(
    [Parameter(Mandatory)][string]$NodeName,
    [Parameter(Mandatory)][string]$Version,
    [string]$UpdateImage
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if(-not (Get-Module powershell-yaml -ListAvailable)) {
    Install-Module powershell-yaml -Scope CurrentUser -Force
}

function Update-Node ($NodeName) {
    
    $node = kubectl get node $nodeName -o yaml | ConvertFrom-Yaml
    $nodeIp = ($node.status.addresses | Where-Object { $_.type -eq "InternalIP" } | Select-Object address).address

    Write-Host "⚙️ Updating $NodeName with IP $nodeIp to version $Version"

    if(-not $UpdateImage) {
        $nodeSchematic = $node.metadata.annotations.'extensions.talos.dev/schematic'
        $updateImage = "factory.talos.dev/metal-installer/$($nodeSchematic):v$($Version)"
    } else {
        $updateImage = $UpdateImage
    }

    talosctl upgrade --nodes $nodeIp --image $updateImage --wait

    Write-Host "⚙️ Update $NodeName succeeeded"
}

if($NodeName -eq "ALL") {
    $nodeNames = (kubectl get nodes -o yaml | ConvertFrom-Yaml).items.metadata.name

    foreach($nodeName in $nodeNames) {
        
        Update-Node $nodeName
    }
} else {
    Update-Node $NodeName
}
