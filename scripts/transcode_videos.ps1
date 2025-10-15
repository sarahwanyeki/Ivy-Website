<#
Transcode original videos to web‑safe H.264 MP4 (and optional VP9 WebM).

Usage (PowerShell):
  - Ensure ffmpeg is installed and on PATH (https://ffmpeg.org/).
  - From repo root, run:
      pwsh ./scripts/transcode_videos.ps1

Notes:
  - Outputs to assets/videos with kebab‑case names used by the site.
  - MP4: H.264 + AAC, yuv420p, +faststart for progressive playback.
  - Add -CreateWebM to also produce WebM (VP9 + Opus) sidecars.
#>

[CmdletBinding()]
param(
  [switch]$CreateWebM
)

function Require-Tool($name) {
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    Write-Error "'$name' is not installed or not on PATH. Please install it and retry." -ErrorAction Stop
  }
}

Require-Tool ffmpeg

$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$srcDir = Join-Path $root 'original_videos'
$outDir = Join-Path $root 'assets/videos'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$map = [ordered]@{
  "CAPPADOCIA TURKEY.mp4"                    = "cappadocia-turkey.mp4"
  "CBF EXPO VIDEO.mp4"                       = "cbf-expo-video.mp4"
  "CHRISTMAS IN BALI.mp4"                    = "christmas-in-bali.mp4"
  "Diani Kenya's #1 Beach Destination.mp4"   = "diani-kenyas-1-beach-destination.mp4"
  "Diani Kenya’s #1 Beach Destination.mp4"   = "diani-kenyas-1-beach-destination.mp4"  # curly apostrophe
  "DREAMWORLD SERVICES 4K.mp4"               = "dreamworld-services-4k.mp4"
  "DUBAI TRAVEL TIPS.mp4"                    = "dubai-travel-tips.mp4"
  "EAST AFRICA BEACHES.mp4"                  = "east-africa-beaches.mp4"
  "NAIROBI LUXURY HOTELS.mp4"                = "nairobi-luxury-hotels.mp4"
  "SAROVA HOTELS VIDEO.mp4"                  = "sarova-hotels-video.mp4"
  "SOLO TRAVELER.mp4"                        = "solo-traveler.mp4"
  "Top 3 Local Getaways.mp4"                 = "top-3-local-getaways.mp4"
  "WHY VISIT DUBAI.mp4"                      = "why-visit-dubai.mp4"
  "Why You Derserve A Holiday.mp4"           = "why-you-deserve-a-holiday.mp4"
  "WILDEBEEST MIGRATION.mp4"                 = "wildebeest-migration.mp4"
  "Your Next Weekend Plan.mp4"               = "your-next-weekend-plan.mp4"
}

foreach ($inName in $map.Keys) {
  $inPath = Join-Path $srcDir $inName
  if (-not (Test-Path -LiteralPath $inPath)) {
    Write-Warning "Missing source: $inName"
    continue
  }

  $outName = $map[$inName]
  $outPath = Join-Path $outDir $outName

  Write-Host "Transcoding -> $outName" -ForegroundColor Cyan
  $ffArgs = @(
    '-y',
    '-i', $inPath,
    '-map', '0:v:0', '-map', '0:a:0?',
    '-c:v', 'libx264', '-preset', 'veryfast', '-crf', '22',
    '-profile:v', 'high', '-level', '4.1', '-pix_fmt', 'yuv420p',
    '-movflags', '+faststart',
    '-c:a', 'aac', '-b:a', '128k', '-ac', '2',
    $outPath
  )
  ffmpeg @ffArgs | Out-Null

  if ($CreateWebM) {
    $outWebm = [System.IO.Path]::ChangeExtension($outPath, '.webm')
    Write-Host "  + WebM -> $(Split-Path -Leaf $outWebm)"
    $ffArgsWebm = @(
      '-y', '-i', $inPath,
      '-map', '0:v:0', '-map', '0:a:0?',
      '-c:v', 'libvpx-vp9', '-b:v', '0', '-crf', '33', '-row-mt', '1',
      '-pix_fmt', 'yuv420p', '-deadline', 'good',
      '-c:a', 'libopus', '-b:a', '96k', '-ac', '2',
      $outWebm
    )
    ffmpeg @ffArgsWebm | Out-Null
  }
}

Write-Host "Done. Verify outputs in $outDir and redeploy." -ForegroundColor Green

