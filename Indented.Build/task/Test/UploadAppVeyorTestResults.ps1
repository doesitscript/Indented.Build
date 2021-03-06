﻿BuildTask UploadAppVeyorTestResults -Stage Test -Order 3 -If { $buildInfo.BuildSystem -eq 'AppVeyor' } -Definition {
    $path = Join-Path $buildInfo.Path.Output ('{0}.xml' -f $buildInfo.ModuleName)
    if (Test-Path $path) {
        $webClient = New-Object System.Net.WebClient
        $webClient.UploadFile(('https://ci.appveyor.com/api/testresults/nunit/{0}' -f $env:APPVEYOR_JOB_ID), $path)
    }
}