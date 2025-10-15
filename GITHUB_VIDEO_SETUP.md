# GitHub Release Video CDN Setup Guide

This guide will help you host your videos on GitHub Releases (100% free) instead of using Git LFS, making them work perfectly on Vercel's free tier.

## Why GitHub Releases?

- **100% Free**: Unlimited bandwidth for public repositories
- **Fast CDN**: GitHub's global CDN delivers videos quickly
- **No Git LFS issues**: Videos hosted separately from your code
- **Works with Vercel Free Tier**: No deployment size limits

## Step 1: Create GitHub Personal Access Token (if needed)

1. Go to https://github.com/settings/tokens/new
2. Name: `Video Upload Token`
3. Select scopes: Check `repo` (Full control of private repositories)
4. Click "Generate token"
5. Copy the token (you'll need it for authentication)

## Step 2: Upload Videos to GitHub Release

### Option A: Using GitHub Web Interface (Easiest)

1. Go to your repository: https://github.com/sarahwanyeki/Ivy-Website
2. Click on "Releases" (right sidebar)
3. Click "Create a new release"
4. Fill in the details:
   - **Tag**: `video-assets-v1.0`
   - **Release title**: `Video Assets`
   - **Description**: `Video files for portfolio website`
5. Drag and drop all videos from `assets/videos/` folder
6. Click "Publish release"

### Option B: Using PowerShell Script (Automated)

1. First, authenticate with GitHub CLI:
   ```powershell
   gh auth login
   ```
   Follow the prompts and authorize in your browser.

2. Run the upload script:
   ```powershell
   cd "f:\Ivy Website"
   .\scripts\upload_videos_to_github.ps1
   ```

## Step 3: Update HTML Files

Run the update script to replace local video paths with GitHub CDN URLs:

```powershell
cd "f:\Ivy Website"
.\scripts\update_video_urls.ps1
```

This will update `videos.html` to use URLs like:
```
https://github.com/sarahwanyeki/Ivy-Website/releases/download/video-assets-v1.0/cappadocia-turkey.mp4
```

## Step 4: Remove Videos from Git LFS

Since videos will be hosted on GitHub Releases, you can remove them from Git LFS:

```powershell
# Remove videos from tracking
git rm assets/videos/*.mp4

# Commit the changes
git add .
git commit -m "Remove videos from repo - now hosted on GitHub Releases CDN"
```

## Step 5: Deploy to Vercel

```powershell
git push origin master
```

Vercel will automatically deploy, and your videos will now load from GitHub's CDN!

## Video URLs Format

After setup, videos will be accessed via:
```
https://github.com/sarahwanyeki/Ivy-Website/releases/download/video-assets-v1.0/[VIDEO-NAME].mp4
```

## Troubleshooting

### Videos not loading?
- Check that the release is published (not draft)
- Verify the release tag is exactly: `video-assets-v1.0`
- Check browser console for 404 errors

### Authentication issues?
- Try: `gh auth refresh -h github.com -s repo`
- Or use the web interface (Option A)

## Benefits

✅ Free unlimited bandwidth
✅ Fast global CDN
✅ Works on Vercel free tier
✅ No Git LFS complications
✅ Easy to update videos (just upload new release assets)

## Video List

Your current videos (15 total, ~575MB):
1. cappadocia-turkey.mp4 (18MB)
2. cbf-expo-video.mp4 (32MB)
3. christmas-in-bali.mp4 (43MB)
4. diani-kenyas-1-beach-destination.mp4 (26MB)
5. dreamworld-services-4k.mp4 (28MB)
6. dubai-travel-tips.mp4 (38MB)
7. east-africa-beaches.mp4 (29MB)
8. nairobi-luxury-hotels.mp4 (53MB)
9. sarova-hotels-video.mp4 (83MB)
10. solo-traveler.mp4 (36MB)
11. top-3-local-getaways.mp4 (46MB)
12. why-visit-dubai.mp4 (36MB)
13. why-you-deserve-a-holiday.mp4 (51MB)
14. wildebeest-migration.mp4 (38MB)
15. your-next-weekend-plan.mp4 (24MB)
