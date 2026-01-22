# Multi-stage Dockerfile to download and unzip files
FROM alpine:latest

# Install required tools
RUN apk update && apk add --no-cache curl unzip

# Build arguments for configuration
ARG VARIANT=default
ARG DOWNLOAD_URL
ARG OUTPUT_DIR=/data

# Set working directory
WORKDIR /app

# Create output directory
RUN mkdir -p ${OUTPUT_DIR}

# Download and unzip files
# The DOWNLOAD_URL can be passed during build time
RUN if [ -n "${DOWNLOAD_URL}" ]; then \
        echo "Downloading from: ${DOWNLOAD_URL}"; \
        curl -L -o /tmp/download.zip "${DOWNLOAD_URL}" && \
        unzip -q /tmp/download.zip -d ${OUTPUT_DIR} && \
        rm /tmp/download.zip; \
    else \
        echo "No DOWNLOAD_URL provided, skipping download"; \
    fi

# Set the default command
CMD ["sh", "-c", "echo 'Image built successfully for variant: ${VARIANT}' && ls -la ${OUTPUT_DIR}"]
