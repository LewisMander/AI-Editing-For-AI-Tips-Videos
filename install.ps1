[CmdletBinding()]
param(
    [ValidateSet("Codex", "Claude", "Both")]
    [string]$Platform = "Codex",

    [string]$CodexRoot,

    [string]$ClaudeRoot
)

$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceSkill = Join-Path $repositoryRoot "ai-tips-editing"

if (-not (Test-Path -LiteralPath (Join-Path $sourceSkill "SKILL.md"))) {
    throw "The ai-tips-editing skill folder is incomplete. Clone or download the full repository and try again."
}

$userProfile = [Environment]::GetFolderPath("UserProfile")
$installTargets = @()

if ($Platform -in @("Codex", "Both")) {
    if ($CodexRoot) {
        $resolvedCodexRoot = [System.IO.Path]::GetFullPath($CodexRoot)
    }
    elseif ($env:CODEX_HOME) {
        $resolvedCodexRoot = [System.IO.Path]::GetFullPath($env:CODEX_HOME)
    }
    else {
        $resolvedCodexRoot = Join-Path $userProfile ".codex"
    }

    $installTargets += [PSCustomObject]@{
        Platform = "Codex"
        SkillsRoot = Join-Path $resolvedCodexRoot "skills"
    }
}

if ($Platform -in @("Claude", "Both")) {
    if ($ClaudeRoot) {
        $resolvedClaudeRoot = [System.IO.Path]::GetFullPath($ClaudeRoot)
    }
    else {
        $resolvedClaudeRoot = Join-Path $userProfile ".claude"
    }

    $installTargets += [PSCustomObject]@{
        Platform = "Claude Code"
        SkillsRoot = Join-Path $resolvedClaudeRoot "skills"
    }
}

foreach ($target in $installTargets) {
    $targetSkill = Join-Path $target.SkillsRoot "ai-tips-editing"
    if (Test-Path -LiteralPath $targetSkill) {
        throw "The skill is already installed for $($target.Platform) at $targetSkill. This installer will not overwrite it."
    }
}

foreach ($target in $installTargets) {
    $targetSkill = Join-Path $target.SkillsRoot "ai-tips-editing"
    New-Item -ItemType Directory -Force -Path $target.SkillsRoot | Out-Null
    Copy-Item -LiteralPath $sourceSkill -Destination $targetSkill -Recurse

    if (-not (Test-Path -LiteralPath (Join-Path $targetSkill "SKILL.md"))) {
        throw "Installation did not complete successfully for $($target.Platform)."
    }

    Write-Output "Installed ai-tips-editing for $($target.Platform) at: $targetSkill"
}

Write-Output "Start a new task or restart the application if the skill does not appear immediately."
