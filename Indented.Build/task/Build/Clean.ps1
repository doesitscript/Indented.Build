BuildTask Clean -Stage Build -Order 0 -Definition {
    $erroractionprefence = 'Stop'

    try {
        if (Get-Module $buildInfo.ModuleName) {
            Remove-Module $buildInfo.ModuleName
        }

        Get-ChildItem $buildInfo.Path.Package.Parent.FullName -Directory -ErrorAction SilentlyContinue |
            Where-Object { [Version]::TryParse($_.Name, [Ref]$null) } |
            Remove-Item -Recurse -Force

        if (Test-Path $buildInfo.Path.Output) {
            Remove-Item $buildInfo.Path.Output -Recurse -Force
        }

        $nupkg = Join-Path $buildInfo.Path.Nuget ('{0}.*.nupkg' -f $buildInfo.ModuleName)
        if (Test-Path $nupkg) {
            Remove-Item $nupkg
        }

        $null = New-Item $buildInfo.Path.Package -ItemType Directory -Force
        $null = New-Item $buildInfo.Path.Output -ItemType Directory -Force
        $null = New-Item $buildInfo.Path.Nuget -ItemType Directory -Force
    } catch {
        throw
    }
}