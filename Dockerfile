# Nextcloud with SMB support for external storage. The official image has neither the
# smbclient PHP extension nor libsmbclient, so files_external cannot offer the SMB backend.
# NEXTCLOUD_TAG selects the official base image; the published tag mirrors it.
ARG NEXTCLOUD_TAG=35.0.3-apache
FROM nextcloud:${NEXTCLOUD_TAG}

# PECL publishes this release as "1.2.0dev" with stability "stable".
ARG SMBCLIENT_VERSION=1.2.0dev

# Pattern of the official image's own extensions: build against the -dev package, then
# keep only the shared libraries the extension links against.
RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends libsmbclient-dev; \
    pecl install "channel://pecl.php.net/smbclient-${SMBCLIENT_VERSION}"; \
    docker-php-ext-enable smbclient; \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')/smbclient.so" \
      | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
      | sort -u | xargs -r dpkg-query --search | cut -d: -f1 | sort -u | xargs -rt apt-mark manual; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/* /tmp/pear; \
    php -m | grep -qx smbclient
