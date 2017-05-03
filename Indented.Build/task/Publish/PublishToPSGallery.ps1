﻿BuildTask PublishToPSGallery -Stage Publish -Order 2 -If { $null -ne $env:NuGetApiKey } -Definition {
    Publish-Module -Path $buildInfo.Path.Package -NuGetApiKey $env:NuGetApiKey -Repository PSGallery -ErrorAction Stop
}