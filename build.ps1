param(
    [ValidateSet(
        'restore',
        'build',
        'test',
        'test-unit',
        'test-integration',
        'format',
        'format-check',
        'analyze',
        'coverage',
        'security',
        'architecture-check',
        'harness-score',
        'check',
        'ci'
    )]
    [string]$Target = 'check'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

function Invoke-RepoCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Action
    )

    Write-Host "==> $Name"
    & $Action

    if ($LASTEXITCODE -ne 0) {
        throw "$Name failed with exit code $LASTEXITCODE"
    }
}

switch ($Target) {
    'restore' {
        Invoke-RepoCommand -Name 'Restore' -Action { dotnet restore MeetingCost.sln --locked-mode }
    }
    'build' {
        Invoke-RepoCommand -Name 'Build' -Action { dotnet build MeetingCost.sln --configuration Release --no-restore }
    }
    'test' {
        Invoke-RepoCommand -Name 'Test' -Action { dotnet test MeetingCost.sln --configuration Release --no-restore --logger 'trx;LogFileName=test-results.trx' }
    }
    'test-unit' {
        Invoke-RepoCommand -Name 'Unit tests' -Action { dotnet test MeetingCost.sln --configuration Release --no-restore --logger 'trx;LogFileName=unit-test-results.trx' --filter 'Category!=Integration' }
    }
    'test-integration' {
        Invoke-RepoCommand -Name 'Integration tests' -Action { dotnet test MeetingCost.sln --configuration Release --no-restore --logger 'trx;LogFileName=integration-test-results.trx' --filter 'Category=Integration' }
    }
    'format' {
        Invoke-RepoCommand -Name 'Format' -Action { dotnet tool restore; dotnet format MeetingCost.sln }
    }
    'format-check' {
        Invoke-RepoCommand -Name 'Format check' -Action { dotnet tool restore; dotnet format MeetingCost.sln --verify-no-changes --verbosity minimal }
    }
    'analyze' {
        Invoke-RepoCommand -Name 'Analyze' -Action {
            dotnet build MeetingCost.sln --configuration Release --no-restore /p:EnforceCodeStyleInBuild=true /p:TreatWarningsAsErrors=true /p:EnableNETAnalyzers=true /p:AnalysisLevel=latest-recommended
        }
    }
    'coverage' {
        Invoke-RepoCommand -Name 'Coverage' -Action {
            dotnet test MeetingCost.sln --configuration Release --no-restore --collect 'XPlat Code Coverage' --results-directory TestResults --logger 'trx;LogFileName=coverage-tests.trx'
        }
    }
    'security' {
        $securityReport = & dotnet list MeetingCost.sln package --vulnerable --include-transitive 2>&1
        Write-Host $securityReport
        if ($securityReport -match 'The following packages have vulnerabilities') {
            throw 'Dependency vulnerabilities were found.'
        }
    }
    'architecture-check' {
        Invoke-RepoCommand -Name 'Architecture check' -Action { dotnet test MeetingCost.sln --configuration Release --no-restore --filter 'Category=Architecture' }
    }
    'harness-score' {
        Invoke-RepoCommand -Name 'Harness Score' -Action { npx --yes harness-score . }
    }
    'check' {
        Invoke-RepoCommand -Name 'Restore' -Action { dotnet restore MeetingCost.sln --locked-mode }
        Invoke-RepoCommand -Name 'Format check' -Action { dotnet tool restore; dotnet format MeetingCost.sln --verify-no-changes --verbosity minimal }
        Invoke-RepoCommand -Name 'Build' -Action { dotnet build MeetingCost.sln --configuration Release --no-restore }
        Invoke-RepoCommand -Name 'Unit tests' -Action { dotnet test MeetingCost.sln --configuration Release --no-restore --filter 'Category!=Integration' }
        Invoke-RepoCommand -Name 'Analyze' -Action { dotnet build MeetingCost.sln --configuration Release --no-restore /p:EnforceCodeStyleInBuild=true /p:TreatWarningsAsErrors=true /p:EnableNETAnalyzers=true /p:AnalysisLevel=latest-recommended }
        $securityReport = & dotnet list MeetingCost.sln package --vulnerable --include-transitive 2>&1
        Write-Host $securityReport
        if ($securityReport -match 'The following packages have vulnerabilities') {
            throw 'Dependency vulnerabilities were found.'
        }
        Invoke-RepoCommand -Name 'Harness Score' -Action { npx --yes harness-score . }
    }
    'ci' {
        & "$PSScriptRoot/build.ps1" check
        if ($LASTEXITCODE -ne 0) {
            throw 'The CI quality gate failed.'
        }
        Invoke-RepoCommand -Name 'Coverage' -Action {
            dotnet test MeetingCost.sln --configuration Release --no-restore --collect 'XPlat Code Coverage' --results-directory TestResults --logger 'trx;LogFileName=ci-tests.trx'
        }
    }
    default {
        throw "Unknown target '$Target'."
    }
}
