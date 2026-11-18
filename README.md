# nextcloud-smb

The official [`nextcloud`](https://hub.docker.com/_/nextcloud) Apache image plus the `smbclient`
PHP extension (PECL) and `libsmbclient`, so Nextcloud's External storage app can mount SMB/CIFS
shares. Nothing else is changed.

Images: `ghcr.io/mhert/nextcloud-smb:<nextcloud-tag>-<revision>`, e.g. `35.0.3-apache-1`, built by
GitHub Actions on every push to `main`. The revision counts rebuilds of the same Nextcloud version.
To follow a new Nextcloud release, change `NEXTCLOUD_TAG` (and reset `REVISION`) in
`.github/workflows/build.yml`.

Local build:

```bash
docker build --build-arg NEXTCLOUD_TAG=35.0.3-apache -t nextcloud-smb .
```
