[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,

    [string]$ContactSheetPath
)

$ErrorActionPreference = "Stop"
$resolvedInput = (Resolve-Path -LiteralPath $InputPath).Path

$probeText = & ffprobe `
    -v error `
    -show_entries "format=duration,size:stream=index,codec_name,width,height,r_frame_rate,pix_fmt,color_range,color_space,color_transfer,color_primaries,sample_rate,channels" `
    -of json `
    $resolvedInput

if ($LASTEXITCODE -ne 0) {
    throw "FFprobe failed with exit code $LASTEXITCODE."
}

$probe = $probeText | ConvertFrom-Json

& ffmpeg -v error -i $resolvedInput -f null NUL
if ($LASTEXITCODE -ne 0) {
    throw "Full video decode failed with exit code $LASTEXITCODE."
}

$resolvedContactSheet = $null
if ($ContactSheetPath) {
    $resolvedContactSheet = [System.IO.Path]::GetFullPath($ContactSheetPath)
    $contactDirectory = Split-Path -Parent $resolvedContactSheet
    if (-not (Test-Path -LiteralPath $contactDirectory)) {
        throw "Contact-sheet directory does not exist: $contactDirectory"
    }

    & ffmpeg -y `
        -v error `
        -i $resolvedInput `
        -vf "fps=1/10,scale=480:270,tile=4x3" `
        -frames:v 1 `
        $resolvedContactSheet

    if ($LASTEXITCODE -ne 0) {
        throw "Contact-sheet generation failed with exit code $LASTEXITCODE."
    }
}

[ordered]@{
    input = $resolvedInput
    decode_passed = $true
    contact_sheet = $resolvedContactSheet
    format = $probe.format
    streams = $probe.streams
} | ConvertTo-Json -Depth 8
