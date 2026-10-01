# Postiz + local patch: preserve urn:li:person mentions in LinkedIn commentary.
# Bump BASE together with the compose image tag when upgrading Postiz; the patch
# script fails the build if upstream changed the fixText pattern.
FROM ghcr.io/gitroomhq/postiz-app:v2.21.10@sha256:1d5a5dc6b896747d1483c01dc2562165bd313ad601b32f6cabb7f7dd08a911a9
COPY patch-linkedin-mentions.js /tmp/patch-linkedin-mentions.js
RUN node /tmp/patch-linkedin-mentions.js
