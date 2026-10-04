#!/usr/bin/env bash
# Publishes the privacy + callback pages to GitHub Pages under your account.
# Run:  bash ~/store-legal/deploy.sh
set -e
cd "$(dirname "$0")"

USER=$(gh api user -q .login)
echo "[*] GitHub user: $USER"

git init -b main -q 2>/dev/null || git init -q
git add -A
git commit -qm "privacy policy + oauth callback" 2>/dev/null || git commit -qm "update" 2>/dev/null || true

echo "[*] creating/pushing repo store-legal ..."
if gh repo view "$USER/store-legal" >/dev/null 2>&1; then
  git remote add origin "https://github.com/$USER/store-legal.git" 2>/dev/null || true
  git branch -M main
  git push -u origin main
else
  gh repo create store-legal --public --source=. --remote=origin --push
fi

echo "[*] enabling GitHub Pages (main / root) ..."
gh api --method POST "repos/$USER/store-legal/pages" \
   -f 'source[branch]=main' -f 'source[path]=/' >/dev/null 2>&1 \
 || gh api --method PUT "repos/$USER/store-legal/pages" \
      -f 'source[branch]=main' -f 'source[path]=/' >/dev/null 2>&1 \
 || echo "    (if this failed, enable Pages once in repo Settings -> Pages -> Branch: main / root)"

echo
echo "================= eBay RuName values ================="
echo "Privacy policy URL : https://$USER.github.io/store-legal/"
echo "Auth accepted URL  : https://$USER.github.io/store-legal/callback.html"
echo "====================================================="
echo "Pages can take ~1 minute to go live. Open the Privacy URL in a browser to confirm."
