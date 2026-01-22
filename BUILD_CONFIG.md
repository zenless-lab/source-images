# Docker Image Build Configuration

This repository contains a Dockerfile and GitHub Actions workflow to automatically build and push Docker images to Docker Hub.

## Features

- **Automated Builds**: Scheduled monthly builds on the 25th of each month
- **Tagged Releases**: Build specific or all variants based on release tags
- **Flexible Configuration**: Support for multiple image variants with custom download URLs

## Setup

### 1. Configure Docker Hub Secrets

Add the following secrets to your GitHub repository:
- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Your Docker Hub access token

### 2. Customize Variants

Edit `.github/workflows/build-push.yml` to define your variants in the `env` section at the top:

```yaml
env:
  REGISTRY: docker.io
  ALL_VARIANTS: '["variant1", "variant2", "variant3"]'
```

Then configure the download URLs for each variant in the `Set build matrix` step by editing the case statement:

```yaml
case "$VARIANT" in
  variant1)
    URL="https://example.com/variant1.zip"
    ;;
  variant2)
    URL="https://example.com/variant2.zip"
    ;;
  # Add more variants as needed
esac
```

## Usage

### Scheduled Builds

The workflow automatically runs on the 25th of every month at 00:00 UTC, building all variants.

### Release Tags

#### Build All Variants
Create a tag matching `release-<version>`:
```bash
git tag release-1.0.0
git push origin release-1.0.0
```

This will build all configured variants with version `1.0.0`.

#### Build Specific Variant
Create a tag matching `release-<name>-<version>`:
```bash
git tag release-variant1-1.0.0
git push origin release-variant1-1.0.0
```

This will build only the `variant1` with version `1.0.0`.

### Manual Trigger

You can also manually trigger the workflow from the GitHub Actions tab using the "Run workflow" button.

## Docker Images

Built images are pushed to Docker Hub with the following tags:
- `<repository>:<variant>-<version>` - Specific version
- `<repository>:<variant>-latest` - Latest build for that variant

## Dockerfile

The Dockerfile supports the following build arguments:
- `VARIANT`: The variant name (e.g., "variant1")
- `DOWNLOAD_URL`: URL to download and extract (must be a zip file)
- `OUTPUT_DIR`: Directory where files are extracted (default: `/data`)

### Building Locally

```bash
docker build \
  --build-arg VARIANT=myvariant \
  --build-arg DOWNLOAD_URL=https://example.com/file.zip \
  -t myimage:latest \
  .
```

## Architecture

1. **setup-matrix job**: Parses the trigger (schedule/tag) and generates a build matrix
2. **build-and-push job**: Builds and pushes Docker images for each variant in the matrix

The workflow uses dynamic matrix generation to efficiently build only the required variants based on the trigger type.
