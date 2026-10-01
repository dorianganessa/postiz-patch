# Postiz LinkedIn mention patch

A minimal, self-verifying patch for [Postiz](https://github.com/gitroomhq/postiz-app)
v2.21.10. It preserves LinkedIn person mentions alongside organization mentions
when Postiz escapes Markdown commentary. The build patches both backend and
orchestrator providers and fails if the expected upstream pattern changes.

The upstream image is pinned by digest. No runtime configuration, account IDs,
API keys, environment files, server addresses, or posting data are included.

## Images

GitHub Actions builds Linux amd64 and arm64 images on pushes to `main` and
publishes them to `ghcr.io/dorianganessa/postiz-patch:sha-<full-commit-sha>`.
Pull requests build and verify the patch without publishing. Use the published
image digest in a deployment to keep it immutable. Publishing does not deploy
or restart a running Postiz instance.

```sh
docker build -t postiz-patch:local .
```

In a Postiz Compose stack, replace only the application's image and remove its
local `build` section. Keep the upstream Postiz database, Redis, Temporal,
configuration, and volume settings from your existing stack:

```yaml
services:
  postiz:
    image: ghcr.io/dorianganessa/postiz-patch@sha256:REPLACE_WITH_PUBLISHED_DIGEST
```

## Upgrades and license

Update the upstream version and digest together, then build. A missing patch
pattern requires review of the new upstream provider implementation. The
published image is based on upstream Postiz v2.21.10, whose source is available
at [the upstream release tag](https://github.com/gitroomhq/postiz-app/tree/v2.21.10).
Postiz and this derivative patch are licensed under AGPL-3.0; see LICENSE.
