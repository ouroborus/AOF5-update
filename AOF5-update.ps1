$ErrorActionPreference = 'Stop'

$Uris = @(
    'https://mediafilez.forgecdn.net/files/4024/417/AE2Things-1.1.1-beta.1.jar',
    'https://mediafilez.forgecdn.net/files/4071/162/AE2WTLib-11.6.3.jar',
    'https://mediafilez.forgecdn.net/files/4022/458/Applied-Botanics-1.3.4.jar',
    'https://mediafilez.forgecdn.net/files/4013/834/appliedenergistics2-11.5.0.jar',
    'https://mediafilez.forgecdn.net/files/4020/978/chipped-2.0.0-fabric.jar',
    'https://mediafilez.forgecdn.net/files/3949/538/cyti-1.0.6.jar',
    'https://mediafilez.forgecdn.net/files/4077/254/dankstorage-1.18.2-3.9.jar',
    'https://mediafilez.forgecdn.net/files/4026/726/DisplayCase-fabric-1.18.2-1.0.3.jar',
    'https://mediafilez.forgecdn.net/files/4023/643/iris-mc1.18.2-1.4.0.jar',
    'https://mediafilez.forgecdn.net/files/4023/623/kibe-1.9.10-BETA%2B1.18.jar',
    'https://mediafilez.forgecdn.net/files/4032/509/probablychests-0.5.5-1.18.2.jar',
    'https://mediafilez.forgecdn.net/files/3959/24/spectrum-1.5.7-1.18.2-magic.jar'
)

$RemoveMods = @(
    'AE2Things-1.1.0-beta.8.jar',
    'AE2WTLib-11.1.4.jar',
    'Applied-Botanics-1.3.1.jar',
    'appliedenergistics2-11.1.5.jar',
    'chipped-1.2.jar',
    'cyti-1.0.5.jar',
    'dankstorage-1.18.2-3.7.1.jar',
    'Display Case-fabric-1.18.2-1.0.0.jar',
    'iris-mc1.18.2-1.2.6.jar',
    'kibe-1.9.9-BETA+1.18.jar',
    'magitekmechs-fabric-MC1.18-1.0.12.jar',
    'probablychests-0.5.3-1.18.2.jar',
    'spectrum-1.5.2-1.18.2-magic.jar',
    'spectrum-1.5.0-1.18.2-magic.jar'
)

If (-Not (Test-Path "manifest.json" -PathType Leaf)) {
    Write-Host 'manifest.json not found. Is this the correct folder?'
    Exit
}

$Decision = $Host.UI.PromptForChoice('Downloads', 'Download mods?', @('&Yes', '&Force', '&Skip', '&Terminate'), 0)
$Force = $false
If ($Decision -Eq 1) {
    $Force = $true
    $Decision = 0
}
If ($Decision -Eq 0) {
    ForEach ($Uri in $Uris) {
        $FileName = 'mods\' + [uri]::UnescapeDataString(($Uri -Split '/', $null, 'SimpleMatch')[-1])
        if ($Force -Or -Not (Test-Path "$FileName" -PathType Leaf)) {
            Write-Host "Downloading $FileName ..."
            Invoke-WebRequest -URI "$Uri" -OutFile "$FileName"
        }
    }
}
ElseIf ($Decision -Eq 2) {
    Write-Host 'Skipping downloads.'
}
Else {
    Exit
}

$Decision = $Host.UI.PromptForChoice('Cleanup', 'Remove old mods?', @('&Yes', '&Skip', '&Terminate'), 0)
If ($Decision -Eq 0) {
    ForEach ($File in $RemoveMods) {
        try {
            Remove-Item "mods\$File"
            Write-Host "Deleted $File"
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            # ignore ItemNotFoundException
        }
    }
}
ElseIf ($Decision -Eq 1) {
    Write-Host 'Skipping cleanup.'
}
Else {
    Exit
}
