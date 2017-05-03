BuildTask UpdateMarkdownHelp -Stage Build -Order 1025 -If { Get-Module platyPS -ListAvailable } -Definition {
    $exceptionMessage = powershell.exe -NoProfile -Command "
        try {
            Import-Module '$($buildInfo.ReleaseManifest.FullName)' -ErrorAction Stop
            New-MarkdownHelp -Module '$($buildInfo.ModuleName)' -OutputFolder '$($buildInfo.Source)\help' -Force

            exit 0
        } catch {
            `$_.Exception.Message

            exit 1
        }
    "
    
    if ($lastexitcode -ne 0) {
        throw $exceptionMessage
    }
}