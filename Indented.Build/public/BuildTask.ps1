function BuildTask {
    <#
    .SYNOPSIS
        Create a build task object.
    .DESCRIPTION
        A build task is a predefined task used to build well-structured PowerShell projects.
    #>

    [CmdletBinding()]
    [OutputType('BuildTask')]
    param (
        # The name of the task.
        [Parameter(Mandatory = $true)]
        [String]$Name,

        # The stage during which the task will be invoked.
        [Parameter(Mandatory = $true)]
        [String]$Stage,

        # Where the task should appear in the build order respective to the stage.
        [Int32]$Order = 1024,

        # The task will only be invoked if the filter condition is true.
        [ScriptBlock]$If = { $true },

        # The task implementation.
        [Parameter(Mandatory = $true)]
        [ScriptBlock]$Definition
    )

    [PSCustomObject]@{
        Name       = $Name
        Stage      = $Stage
        If         = $If
        Order      = $Order
        Definition = $Definition
    } | Add-Member -TypeName 'BuildTask' -PassThru
}