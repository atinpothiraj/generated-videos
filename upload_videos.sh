#!/bin/bash

# Batch Upload Script for GitHub Video Releases
# This script automates the process of uploading multiple videos to GitHub releases

# Configuration
# Set GITHUB_TOKEN environment variable before running this script
# export GITHUB_TOKEN="your_token_here"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
REPO_OWNER="atinpothiraj"
REPO_NAME="generated-videos"
VIDEO_DIR="/nas-ssd/atin/upload-vid/test/videos"

# Function to create a release and upload videos
create_release_with_videos() {
    local tag_name="$1"
    local release_name="$2"
    local release_body="$3"
    local video_path="$4"
    
    echo "Creating release: $tag_name"
    
    # Create the release
    local release_response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -X POST "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases" \
        -d "{\"tag_name\":\"$tag_name\",\"target_commitish\":\"main\",\"name\":\"$release_name\",\"body\":\"$release_body\",\"draft\":false,\"prerelease\":false}")
    
    # Extract release ID and upload URL
    local release_id=$(echo "$release_response" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
    local upload_url=$(echo "$release_response" | grep -o '"upload_url":"[^"]*' | cut -d'"' -f4)
    
    if [ -z "$release_id" ]; then
        echo "Error: Failed to create release"
        return 1
    fi
    
    echo "Release created with ID: $release_id"
    
    # Upload videos
    for video_file in "$video_path"/*.mp4; do
        if [ -f "$video_file" ]; then
            local filename=$(basename "$video_file")
            echo "Uploading: $filename"
            
            curl -s -H "Authorization: token $GITHUB_TOKEN" \
                -H "Content-Type: video/mp4" \
                --data-binary @"$video_file" \
                "$upload_url?name=$filename"
            
            echo "Uploaded: $filename"
        fi
    done
    
    echo "Release $tag_name completed successfully!"
}

# Example usage:
# create_release_with_videos "v1.1-wan2-batch1" "Wan2 Videos - Batch 1" "First batch of Wan2 generated videos" "/path/to/wan2/videos"

echo "GitHub Video Upload Script Ready"
echo "Usage: create_release_with_videos <tag> <name> <description> <video_directory>"
