# Postiz + local patch: preserve urn:li:person mentions in LinkedIn commentary.
# Bump BASE together with the compose image tag when upgrading Postiz; the patch
# script fails the build if upstream changed the fixText pattern.
FROM ghcr.io/gitroomhq/postiz-app:v2.25.3@sha256:1e376ff2cb781022d528f171719cf174cf693a985a30cb40eefb13eae3ddda13
COPY patch-linkedin-mentions.js /tmp/patch-linkedin-mentions.js
RUN node /tmp/patch-linkedin-mentions.js
# Use the exact Prisma CLI already shipped with the image. Startup must also
# work without npm access, and must not resolve fresh tooling at deploy time.
RUN node -e 'const fs = require("fs"); const p = require("./package.json"); if (require("prisma/package.json").version !== "6.5.0") throw new Error("Review Prisma upgrade"); p.scripts["prisma-db-push"] = "prisma db push --schema ./libraries/nestjs-libraries/src/database/prisma/schema.prisma"; fs.writeFileSync("package.json", JSON.stringify(p, null, 2) + "\n");'
