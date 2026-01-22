FROM ubuntu:noble AS downloader

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        aria2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /downloads
ARG DOWNLOAD_URL
ARG FILE_NAME
ARG ARIA2_OPTIONS="-x 16 -s 16"
RUN aria2c ${ARIA2_OPTIONS} -d /downloads -o "${FILE_NAME}" "${DOWNLOAD_URL}"

FROM scratch AS source
COPY --from=downloader /downloads /downloads

FROM ubuntu:noble AS unpacker
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        tar \
        gzip \
        pigz \
        bzip2 \
        pbzip2 \
        xz-utils \
        zstd \
        zip \
        unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /unpacked
RUN --mount=type=bind,from=downloader,source=/downloads,target=/source \
    for file in /source/*; do \
        case "$file" in \
            *.tar.gz|*.tgz)   tar -I pigz -xf "$file" -C /unpacked ;; \
            *.tar.bz2|*.tbz2) tar -I pbzip2 -xf "$file" -C /unpacked ;; \
            *.tar.xz|*.txz)   tar -I 'xz -T0' -xf "$file" -C /unpacked ;; \
            *.tar.zst)        zstd -T0 -d "$file" --stdout | tar -xf - -C /unpacked ;; \
            *.tar)            tar -xf "$file" -C /unpacked ;; \
            *.zip)            unzip "$file" -d /unpacked ;; \
            *)                echo "Unsupported file format: $file" ;; \
        esac; \
    done

FROM scratch AS unpacked
COPY --from=unpacker /unpacked /unpacked
