$ErrorActionPreference = 'Stop'

$project = 'MeetingCost.sln'
if (-not (Test-Path $project)) {
    exit 0
}

$dotnet = Get-Command dotnet -ErrorAction SilentlyContinue
if ($null -eq $dotnet) {
    Write-Warning 'dotnet not found; skipping quick .NET validation.'
    exit 0
}

Write-Host 'Running quick .NET validation after edit...'
& dotnet build $project --configuration Release --no-restore
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& dotnet test $project --configuration Release --no-restore --filter 'Category!=Integration' --logger 'trx;LogFileName=hook-check.trx'
exit $LASTEXITCODE
