[CmdletBinding()]
param(
    [switch]$RequireRemotion
)

$ErrorActionPreference = 'Stop'

$checks = @(
    [pscustomobject]@{
        Name = 'FFmpeg'
        Command = 'ffmpeg'
        Arguments = @('-version')
        Required = $true
    },
    [pscustomobject]@{
        Name = 'FFprobe'
        Command = 'ffprobe'
        Arguments = @('-version')
        Required = $true
    },
    [pscustomobject]@{
        Name = 'Node.js'
        Command = 'node'
        Arguments = @('--version')
        Required = [bool]$RequireRemotion
    },
    [pscustomobject]@{
        Name = 'npm'
        Command = 'npm'
        Arguments = @('--version')
        Required = [bool]$RequireRemotion
    },
    [pscustomobject]@{
        Name = 'npx'
        Command = 'npx'
        Arguments = @('--version')
        Required = [bool]$RequireRemotion
    }
)

$missingRequired = [System.Collections.Generic.List[string]]::new()
$missingOptional = [System.Collections.Generic.List[string]]::new()

Write-Host 'Checking AI Tips video editing requirements...'
Write-Host ''

foreach ($check in $checks) {
    $resolved = Get-Command $check.Command -ErrorAction SilentlyContinue | Select-Object -First 1

    if (-not $resolved) {
        if ($check.Required) {
            $missingRequired.Add($check.Name)
            Write-Host ("[MISSING] {0} (required)" -f $check.Name) -ForegroundColor Red
        }
        else {
            $missingOptional.Add($check.Name)
            Write-Host ("[OPTIONAL] {0} is not installed" -f $check.Name) -ForegroundColor Yellow
        }
        continue
    }

    try {
        $versionOutput = & $resolved.Source @($check.Arguments) 2>&1 | Select-Object -First 1
        $version = [string]$versionOutput
        Write-Host ("[OK] {0}: {1}" -f $check.Name, $version.Trim()) -ForegroundColor Green
    }
    catch {
        if ($check.Required) {
            $missingRequired.Add($check.Name)
            Write-Host ("[ERROR] {0} was found but could not run" -f $check.Name) -ForegroundColor Red
        }
        else {
            $missingOptional.Add($check.Name)
            Write-Host ("[OPTIONAL] {0} was found but could not run" -f $check.Name) -ForegroundColor Yellow
        }
    }
}

Write-Host ''

if ($missingRequired.Count -gt 0) {
    Write-Host ("Setup is incomplete. Missing: {0}" -f ($missingRequired -join ', ')) -ForegroundColor Red
    Write-Host 'See the Windows setup section in README.md, then reopen PowerShell and run this check again.'
    exit 1
}

Write-Host 'Ready for FFmpeg-based video editing.' -ForegroundColor Green

if ($missingOptional.Count -eq 0) {
    Write-Host 'Ready to create and use a Remotion project.' -ForegroundColor Green
}
elseif (-not $RequireRemotion) {
    Write-Host 'Install Node.js LTS if you also want to use Remotion.' -ForegroundColor Yellow
}

exit 0
