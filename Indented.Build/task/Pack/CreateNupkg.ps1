BuildTask CreateNupkg -Stage Pack -Order 3 -Definition {
    $path = [System.IO.Path]::Combine($buildInfo.Path.Output, 'pack', $buildInfo.ModuleName)

    # Add module content
    Write-Host $path
    Write-Host $buildInfo.Path.Package

    $null = New-Item $path -ItemType Directory -Force
    Copy-Item $buildInfo.Path.Package -Destination $path -Recurse
    $null = New-Item (Join-Path $path 'tools') -ItemType Directory

    # Create a generic install script
    $destination = '"$env:PROGRAMFILES\WindowsPowerShell\Modules\{0}"' -f $buildInfo.ModuleName
    @(
        'if (Test-Path {0}) {{' -f $destination
        '    Remove-Item {0} -Recurse' -f $destination
        '}'
        'Copy-Item "$psscriptroot\..\{0}" -Destination {1} -Recurse -Force' -f $buildInfo.ModuleName, $destination
    ) | Out-File (Join-Path $path 'tools\install.ps1') -Encoding UTF8

    # deploy.ps1 for Octopus Deploy
    '& "$psscriptroot\tools\install.ps1"' | Out-File (Join-Path $path 'deploy.ps1') -Encoding UTF8

    # chocolateyInstall.ps1
    '& "$psscriptroot\install.ps1"' | Out-File (Join-Path $path 'tools\chocolateyInstall.ps1') -Encoding UTF8

    Push-Location $path

    nuget pack -OutputDirectory $buildInfo.Path.Nuget

    Pop-Location
}