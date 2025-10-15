# Update Video URLs in HTML to use GitHub Release CDN
# This script replaces local video paths with GitHub CDN URLs

$repo = "sarahwanyeki/Ivy-Website"
$releaseTag = "video-assets-v1.0"
$baseUrl = "https://github.com/$repo/releases/download/$releaseTag"

$htmlFile = "videos.html"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Update Video URLs Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if HTML file exists
if (-not (Test-Path $htmlFile)) {
    Write-Host "ERROR: $htmlFile not found!" -ForegroundColor Red
    exit 1
}

Write-Host "Reading $htmlFile..." -ForegroundColor Yellow
$content = Get-Content $htmlFile -Raw

# Create backup
$backupFile = "$htmlFile.backup"
Write-Host "Creating backup at $backupFile..." -ForegroundColor Yellow
Copy-Item $htmlFile $backupFile -Force

# Replace local video paths with GitHub CDN URLs
Write-Host "Updating video URLs..." -ForegroundColor Yellow

$content = $content -replace 'assets/videos/', "$baseUrl/"

# Save updated content
Set-Content $htmlFile -Value $content -NoNewline

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SUCCESS!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Video URLs have been updated to use GitHub CDN" -ForegroundColor Green
Write-Host ""
Write-Host "Base URL: $baseUrl" -ForegroundColor Yellow
Write-Host ""
Write-Host "Backup saved at: $backupFile" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Test your website locally to ensure videos work" -ForegroundColor White
Write-Host "2. Commit and push changes to deploy to Vercel" -ForegroundColor White
Write-Host "3. Videos will now load from GitHub's CDN (free & fast!)" -ForegroundColor White
