BuildTask BuildProject -Stage Build -Order 0 -If { (Test-Path (Join-Path $buildInfo.Path.Source 'class*\*.*proj')) -and -not (Test-Path (Join-Path $buildInfo.Path.Source 'class*\*.sln')) } -Definition {
    try {
        Push-Location (Resolve-Path 'class*').Path

        $null = Get-Command msbuild
        
        Get-Item '*.*proj' | ForEach-Object {
            $proj = [Xml](Get-Content $_.FullName)
            if ($proj.Project.PropertyGroup.OutputType -eq 'winexe') {
                $outputPath = Join-Path $buildInfo.Path.Package.FullName 'bin'
            } else {
                $outputPath = Join-Path $buildInfo.Path.Package.FullName 'lib'
            }
            if (-not (Test-Path $outputPath)) {
                $null = New-Item $outputPath -ItemType Directory -Force
            }

            msbuild /t:Clean /t:Build /p:OutputPath=$outputPath /p:DebugSymbols=false /p:DebugType=None $_.Name
        }
    } catch {
        throw
    } finally {
        Pop-Location
    }
}