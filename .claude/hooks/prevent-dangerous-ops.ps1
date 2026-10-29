$ErrorActionPreference = 'Stop'

$input = $args -join ' '
if ([string]::IsNullOrWhiteSpace($input)) {
    exit 0
}

$blockedPatterns = @(
    'git reset --hard',
    'git clean -fd',
    'rm -rf /',
    'sudo rm',
    'curl .*\| bash',
    'wget .*\| bash'
)

foreach ($pattern in $blockedPatterns) {
    if ($input -match $pattern) {
        Write-Error "Blocked dangerous command: $input"
        exit 1
    }
}

exit 0
