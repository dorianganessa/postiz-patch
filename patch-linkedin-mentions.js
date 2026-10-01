// Build-time patch for Postiz LinkedIn provider.
// Upstream fixText() whitelists only urn:li:organization mentions from Markdown
// escaping, so urn:li:person mentions (e.g. the author self-tag in a signature)
// get escaped into dead text. Widen the whitelist to person + organization.
// Self-verifying: exits non-zero if the base image no longer contains the exact
// upstream pattern, so a version bump fails the build instead of silently
// dropping the fix.
const fs = require("fs");
const files = [
  "/app/apps/orchestrator/dist/libraries/nestjs-libraries/src/integrations/social/linkedin.provider.js",
  "/app/apps/backend/dist/libraries/nestjs-libraries/src/integrations/social/linkedin.provider.js",
];
const OLD = "/@\\[.+?]\\(urn:li:organization.+?\\)/g";
const NEW = "/@\\[.+?]\\(urn:li:(?:organization|person).+?\\)/g";
let done = 0;
for (const f of files) {
  const s = fs.readFileSync(f, "utf8");
  if (s.includes(NEW) && !s.includes(OLD)) {
    console.log("already patched:", f);
    done++;
    continue;
  }
  if (!s.includes(OLD)) {
    console.error("FAIL pattern not found (base image changed?):", f);
    process.exit(1);
  }
  fs.writeFileSync(f, s.split(OLD).join(NEW));
  console.log("patched:", f);
  done++;
}
if (done !== files.length) {
  console.error("FAIL not all files patched");
  process.exit(1);
}
console.log("linkedin mention patch OK");
