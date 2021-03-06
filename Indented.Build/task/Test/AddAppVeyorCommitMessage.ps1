﻿BuildTask AddAppveyorCommitMessage -Stage Test -Order 3 -If { $buildInfo.BuildSystem -eq 'AppVeyor' } -Definition {
    # Pester
    $pester = Invoke-Pester @params

    $path = Join-Path $buildInfo.Path.Output 'pester-output.xml'
    if (Test-Path $path) {
        $pester = Import-CliXml $path

        $params = @{
            Message  = 'Passed {0} of {1} tests' -f $pester.PassedCount, $pester.TotalCount
            Category = 'Information'
        }
        if ($pester.FailedCount -gt 0) {
            $params.Category = 'Warning'
        }
        Add-AppVeyorCompilationMessage @params

        if ($pester.CodeCoverage) {
            [Double]$codeCoverage = $pester.CodeCoverage.NumberOfCommandsExecuted / $pester.CodeCoverage.NumberOfCommandsAnalyzed

            $params = @{
                Message  = '{0:P2} test coverage' -f $codeCoverage
                Category = 'Information'
            }
            if ($codecoverage -lt $buildInfo.CodeCoverageThreshold) {
                $params.Category = 'Warning'
            }
            Add-AppVeyorCompilationMessage @params
        }
    }

    # Solution
    Get-ChildItem $buildInfo.Path.Output -Filter *.dll.xml | ForEach-Object {
        $report = [Xml](Get-Content $_.FullName -Raw)
        $params = @{
            Message = 'Passed {0} of {1} solution tests in {2}' -f $report.'test-run'.passed,
                                                                    $report.'test-run'.total,
                                                                    $report.'test-run'.'test-suite'.name
            Category = 'Information'
        }
        if ([Int]$report.'test-run'.failed -gt 0) {
            $params.Category = 'Warning'
        }
        Add-AppVeyorCompilationMessage @params
    }
}