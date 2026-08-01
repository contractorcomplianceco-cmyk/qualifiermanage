#!/usr/bin/env bash
# QualifierManageOS — internal staff deploy (qualifiers.cagteam.net)
# Audience: [INTERNAL ONLY]
# Approved tip to deploy is passed as $1 (full SHA) or defaults to origin/main tip.
#
# Usage (from a machine that can SSH to the host):
#   export QMOS_DEPLOY_HOST=ubuntu@qualifiers.cagteam.net   # or user@23.22.77.237
#   ./scripts/deploy-internal.sh 25a8ab6ee77f053b582a1ddbed1e695cb415ac98
#
# Optional:
#   QMOS_WEB_ROOT=/var/www/qualifiers.cagteam.net   # skip nginx root discovery
#   QMOS_SSH_OPTS='-i ~/.ssh/your_key'
set -euo pipefail

APPROVED_SHA="${1:-}"
HOST="${QMOS_DEPLOY_HOST:-}"
SSH_OPTS=${QMOS_SSH_OPTS:-}

if [[ -z "$HOST" ]]; then
  echo "Set QMOS_DEPLOY_HOST=user@qualifiers.cagteam.net (SSH user that can write the web root)." >&2
  exit 1
fi

if [[ -z "$APPROVED_SHA" ]]; then
  echo "Usage: $0 <full-commit-sha>" >&2
  exit 1
fi

if [[ ! "$APPROVED_SHA" =~ ^[0-9a-f]{40}$ ]]; then
  echo "Refusing: pass the full 40-char SHA (got: $APPROVED_SHA)" >&2
  exit 1
fi

echo "Deploying $APPROVED_SHA → $HOST (internal staff only)"

# shellcheck disable=SC2086
ssh $SSH_OPTS -o BatchMode=yes -o StrictHostKeyChecking=accept-new "$HOST" bash -s -- "$APPROVED_SHA" <<'REMOTE'
set -euo pipefail
SHA="$1"

discover_root() {
  if [[ -n "${QMOS_WEB_ROOT:-}" && -d "$QMOS_WEB_ROOT" ]]; then
    echo "$QMOS_WEB_ROOT"
    return
  fi
  for candidate in \
    /var/www/qualifiers.cagteam.net \
    /var/www/qualifiermanage \
    /var/www/qmos \
    /var/www/html \
    /home/ubuntu/qualifiermanage \
    /home/ubuntu/apps/qualifiermanage \
    /srv/qualifiermanage
  do
    if [[ -f "$candidate/QualifierManageOS.dc.html" || -d "$candidate/.git" ]]; then
      echo "$candidate"
      return
    fi
  done
  # nginx site root for this server_name
  if command -v nginx >/dev/null 2>&1; then
    conf=$(grep -Rsl 'qualifiers\.cagteam\.net' /etc/nginx 2>/dev/null | head -1 || true)
    if [[ -n "$conf" ]]; then
      root=$(awk '/^\s*root\s+/ {gsub(/;/,""); print $2; exit}' "$conf" || true)
      if [[ -n "$root" && -d "$root" ]]; then
        echo "$root"
        return
      fi
    fi
  fi
  echo "ERROR: could not find web root. Set QMOS_WEB_ROOT on the remote." >&2
  exit 2
}

ROOT="$(discover_root)"
echo "web_root=$ROOT"
cd "$ROOT"

if [[ -d .git ]]; then
  git fetch --prune origin
  git checkout --force "$SHA"
  git reset --hard "$SHA"
  git clean -fd -e '.env' -e '.env.*' -e 'node_modules'
else
  echo "ERROR: $ROOT is not a git checkout. Clone the repo there once, then re-run." >&2
  exit 3
fi

# Evidence file for post-deploy verify (still behind basic-auth)
printf '%s\n' "$SHA" > DEPLOYED_SHA.txt
printf 'deployed_at=%s\nbranch=main\nsha=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$SHA" > DEPLOYED.txt

# Optional: refresh static deps if package.json changed (serve not required in prod)
if [[ -f package.json ]] && command -v npm >/dev/null 2>&1; then
  if [[ ! -d node_modules ]]; then
    npm ci --omit=dev 2>/dev/null || npm install --omit=dev 2>/dev/null || true
  fi
fi

# Reload nginx if we can (config-only; harmless if denied)
if command -v nginx >/dev/null 2>&1; then
  sudo nginx -t 2>/dev/null && sudo systemctl reload nginx 2>/dev/null || true
fi

echo "DEPLOY_OK sha=$(git rev-parse HEAD) root=$ROOT"
git rev-parse HEAD
test "$(git rev-parse HEAD)" = "$SHA"
REMOTE

echo
echo "Remote deploy finished. Verify:"
echo "  curl -u 'USER:PASS' https://qualifiers.cagteam.net/DEPLOYED_SHA.txt"
echo "  # expect: $APPROVED_SHA"
