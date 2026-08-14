[CmdletBinding()]
param(
    [string]$CodexRoot
)

$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceSkill = Join-Path $repositoryRoot "ai-tips-editing"

if (-not (Test-Path -LiteralPath (Join-Path $sourceSkill "SKILL.md"))) {
    throw "The ai-tips-editing skill folder is incomplete. Clone or download the full repository and try again."
}

if ($CodexRoot) {
    $resolvedCodexRoot = [System.IO.Path]::GetFullPath($CodexRoot)
}
elseif ($env:CODEX_HOME) {
    $resolvedCodexRoot = [System.IO.Path]::GetFullPath($env:CODEX_HOME)
}
else {
    $userProfile = [Environment]::GetFolderPath("UserProfile")
    $resolvedCodexRoot = Join-Path $userProfile ".codex"
}

$skillsRoot = Join-Path $resolvedCodexRoot "skills"
$targetSkill = Join-Path $skillsRoot "ai-tips-editing"

if (Test-Path -LiteralPath $targetSkill) {
    throw "The skill is already installed at $targetSkill. This installer will not overwrite it."
}

New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null
Copy-Item -LiteralPath $sourceSkill -Destination $targetSkill -Recurse

if (-not (Test-Path -LiteralPath (Join-Path $targetSkill "SKILL.md"))) {
    throw "Installation did not complete successfully."
}

Write-Output "Installed ai-tips-editing at: $targetSkill"
Write-Output "Start a new Codex task or restart Codex if the skill does not appear immediately."
