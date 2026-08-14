[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath,

    [switch]$Force
)

$ErrorActionPreference = "Stop"

$resolvedInput = (Resolve-Path -LiteralPath $InputPath).Path
$resolvedOutput = [System.IO.Path]::GetFullPath($OutputPath)

if ($resolvedInput -eq $resolvedOutput) {
    throw "InputPath and OutputPath must be different. Preserve the intermediate and raw source."
}

if ((Test-Path -LiteralPath $resolvedOutput) -and -not $Force) {
    throw "Output already exists. Use a new versioned filename or pass -Force explicitly."
}

$outputDirectory = Split-Path -Parent $resolvedOutput
if (-not (Test-Path -LiteralPath $outputDirectory)) {
    throw "Output directory does not exist: $outputDirectory"
}

& ffmpeg -y `
    -i $resolvedInput `
    -vf "scale=in_range=pc:out_range=tv,eq=contrast=1.06:brightness=-0.015:saturation=1.02,unsharp=5:5:0.35:5:5:0.0,format=yuv420p" `
    -c:v libx264 `
    -preset slow `
    -crf 16 `
    -colorspace bt709 `
    -color_primaries bt709 `
    -color_trc bt709 `
    -color_range tv `
    -bsf:v "h264_metadata=video_full_range_flag=0:colour_primaries=1:transfer_characteristics=1:matrix_coefficients=1" `
    -c:a copy `
    -movflags +faststart `
    $resolvedOutput

if ($LASTEXITCODE -ne 0) {
    throw "FFmpeg colour finalisation failed with exit code $LASTEXITCODE."
}

Get-Item -LiteralPath $resolvedOutput | Select-Object FullName, Length, LastWriteTime

