# Upload Videos to GitHub Release
# This script uploads all videos to a GitHub release to serve them via CDN

$repo = "sarahwanyeki/Ivy-Website"
$releaseTag = "video-assets-v1.0"
$releaseName = "Video Assets"
$releaseDescription = "Video files for portfolio website - served via GitHub CDN"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitHub Video Upload Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if gh CLI is installed
Write-Host "Checking for GitHub CLI..." -ForegroundColor Yellow
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue
if (-not $ghInstalled) {
    Write-Host "ERROR: GitHub CLI (gh) is not installed!" -ForegroundColor Red
    Write-Host "Please install it from: https://cli.github.com/" -ForegroundColor Yellow
    Write-Host "Or run: winget install --id GitHub.cli" -ForegroundColor Yellow
    exit 1
}

Write-Host "GitHub CLI found!" -ForegroundColor Green
Write-Host ""

# Check if user is authenticated
Write-Host "Checking GitHub authentication..." -ForegroundColor Yellow
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Not authenticated with GitHub!" -ForegroundColor Red
    Write-Host "Please run: gh auth login" -ForegroundColor Yellow
    exit 1
}

Write-Host "Authentication successful!" -ForegroundColor Green
Write-Host ""

# Get video files
$videoPath = "assets/videos"
$videos = Get-ChildItem -Path $videoPath -Filter *.mp4

if ($videos.Count -eq 0) {
    Write-Host "ERROR: No video files found in $videoPath" -ForegroundColor Red
    exit 1
}

Write-Host "Found $($videos.Count) video files to upload" -ForegroundColor Green
Write-Host ""

# Check if release already exists
Write-Host "Checking if release already exists..." -ForegroundColor Yellow
$existingRelease = gh release view $releaseTag 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "Release '$releaseTag' already exists." -ForegroundColor Yellow
    $response = Read-Host "Do you want to delete and recreate it? (y/n)"
    if ($response -eq 'y') {
        Write-Host "Deleting existing release..." -ForegroundColor Yellow
        gh release delete $releaseTag --yes
        Write-Host "Release deleted!" -ForegroundColor Green
    } else {
        Write-Host "Using existing release. Will add/update assets." -ForegroundColor Yellow
    }
} else {
    # Create new release
    Write-Host "Creating new release '$releaseTag'..." -ForegroundColor Yellow
    gh release create $releaseTag --title $releaseName --notes $releaseDescription
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to create release!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Release created successfully!" -ForegroundColor Green
}

Write-Host ""

# Upload videos
Write-Host "Uploading videos..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$successCount = 0
$failCount = 0

foreach ($video in $videos) {
    $fileName = $video.Name
    $filePath = $video.FullName
    $fileSizeMB = [math]::Round($video.Length / 1MB, 2)

    Write-Host ""
    Write-Host "Uploading: $fileName ($fileSizeMB MB)..." -ForegroundColor Yellow

    # Upload the file
    gh release upload $releaseTag $filePath --clobber

    if ($LASTEXITCODE -eq 0) {
        Write-Host "  SUCCESS: $fileName uploaded!" -ForegroundColor Green
        $successCount++
    } else {
        Write-Host "  ERROR: Failed to upload $fileName" -ForegroundColor Red
        $failCount++
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Upload Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total videos: $($videos.Count)" -ForegroundColor White
Write-Host "Successful: $successCount" -ForegroundColor Green
Write-Host "Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($successCount -gt 0) {
    Write-Host "Videos are now available at:" -ForegroundColor Cyan
    Write-Host "https://github.com/$repo/releases/tag/$releaseTag" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "CDN URL format:" -ForegroundColor Cyan
    Write-Host "https://github.com/$repo/releases/download/$releaseTag/[VIDEO-NAME].mp4" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Next step: Run the update_video_urls.ps1 script to update your HTML files" -ForegroundColor Green
}
