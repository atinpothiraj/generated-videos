# GitHub Video Hosting Workflow Documentation

## Overview
This repository hosts AI-generated videos using GitHub Releases for research and MTurk annotation tasks. Videos are organized by model type and uploaded as release assets to avoid repository size limits.

## Repository Structure
```
/nas-ssd/atin/upload-vid/test/
├── videos/                    # Local video storage (not committed to git)
│   ├── wan2/                  # Wan2 model videos
│   ├── hunyuan/               # HunyuanVideo model videos
│   └── sora2/                 # Sora2 model videos
├── upload_videos.sh           # Batch upload script
├── video_urls.json           # URL mapping for MTurk integration
├── README.md                 # Repository documentation
└── .gitignore               # Excludes video files from git
```

## Workflow Steps

### 1. Prepare Videos
- Copy videos to appropriate model directory (`videos/{model}/`)
- Ensure filenames are descriptive and unique
- Videos are automatically excluded from git commits via `.gitignore`

### 2. Create Release
Use the GitHub API to create a new release:
```bash
curl -H "Authorization: token YOUR_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     -X POST https://api.github.com/repos/atinpothiraj/generated-videos/releases \
     -d '{"tag_name":"v1.1-batch-name","target_commitish":"main","name":"Release Name","body":"Description","draft":false,"prerelease":false}'
```

### 3. Upload Videos
Upload videos as release assets:
```bash
curl -H "Authorization: token YOUR_TOKEN" \
     -H "Content-Type: video/mp4" \
     --data-binary @"video_file.mp4" \
     "UPLOAD_URL?name=video_file.mp4"
```

### 4. Update URL Mapping
Update `video_urls.json` with new video URLs for MTurk integration.

## Batch Upload Script

The `upload_videos.sh` script automates the process:

```bash
# Make script executable
chmod +x upload_videos.sh

# Upload a batch of videos
create_release_with_videos "v1.1-wan2-batch1" "Wan2 Videos - Batch 1" "First batch of Wan2 videos" "/path/to/videos"
```

## MTurk Integration

### Direct Video URLs
Videos are accessible via direct download URLs:
```
https://github.com/atinpothiraj/generated-videos/releases/download/{release_tag}/{filename}
```

### Example URL
```
https://github.com/atinpothiraj/generated-videos/releases/download/v1.0-test/t2v-14B_1280x720_4_1_Two_pillows_on_a_table_and_two_grabber_tools_hangi_20250821_153622.mp4
```

### URL Mapping
The `video_urls.json` file provides structured access to all video URLs, organized by:
- Model type (wan2, hunyuan, sora2)
- Release batches
- Individual video metadata
- Direct download URLs

## Cost Analysis
- **GitHub Releases**: $0 (unlimited storage and bandwidth)
- **File size limit**: 2GB per file (well above our 4.9MB videos)
- **Total capacity**: No explicit limit on release size

## Next Steps for Full Deployment

1. **Organize existing videos** by model type
2. **Create batch releases** (e.g., 20-30 videos per release)
3. **Update video_urls.json** with all video mappings
4. **Test MTurk integration** with sample URLs
5. **Deploy annotation platform** with GitHub video URLs

## Repository URLs
- **Repository**: https://github.com/atinpothiraj/generated-videos
- **Releases**: https://github.com/atinpothiraj/generated-videos/releases
- **Test Video**: https://github.com/atinpothiraj/generated-videos/releases/download/v1.0-test/t2v-14B_1280x720_4_1_Two_pillows_on_a_table_and_two_grabber_tools_hangi_20250821_153622.mp4
