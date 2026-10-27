# Postiz + local patch: preserve urn:li:person mentions in LinkedIn commentary.
# Bump BASE together with the compose image tag when upgrading Postiz; the patch
# script fails the build if upstream changed the fixText pattern.
FROM ghcr.io/gitroomhq/postiz-app:v2.25.3@sha256:1e376ff2cb781022d528f171719cf174cf693a985a30cb40eefb13eae3ddda13
COPY patch-linkedin-mentions.js /tmp/patch-linkedin-mentions.js
RUN node /tmp/patch-linkedin-mentions.js
