# source-images
An automated tool for migrating and syncing software and data to Docker Hub.

## Quick Start

This repository automatically builds and pushes Docker images to Docker Hub based on:
1. **Monthly Schedule**: Automatically builds all variants on the 25th of each month
2. **Release Tags**: Build images by pushing tags

### Setup Requirements

1. Add Docker Hub secrets to your repository:
   - `DOCKERHUB_USERNAME`: Your Docker Hub username
   - `DOCKERHUB_TOKEN`: Your Docker Hub access token

### Usage

**Build all variants:**
```bash
git tag release-1.0.0
git push origin release-1.0.0
```

**Build specific variant only:**
```bash
git tag release-variant1-1.0.0
git push origin release-variant1-1.0.0
```

For detailed configuration and customization, see [BUILD_CONFIG.md](BUILD_CONFIG.md).
