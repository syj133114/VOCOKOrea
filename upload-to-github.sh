#!/usr/bin/env bash
set -euo pipefail
source_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_url='https://github.com/syj133114/VOCOKOrea.git'
for item in index.html race-support.html event-seorak.html assets; do
  if [[ ! -e "$source_dir/$item" ]]; then
    echo "Missing: $item" >&2
    exit 1
  fi
done
upload_dir="$(mktemp -d /tmp/vocokorea-upload.XXXXXX)"
echo "Preparing upload in $upload_dir"
git clone "$repo_url" "$upload_dir/repo"
cd "$upload_dir/repo"
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  git symbolic-ref HEAD refs/heads/main
fi
cp "$source_dir/index.html" "$source_dir/race-support.html" "$source_dir/event-seorak.html" .
mkdir -p assets
cp -R "$source_dir/assets/." assets/
git add -- index.html race-support.html event-seorak.html assets
if git diff --cached --quiet; then
  echo 'The repository already contains these files.'
  exit 0
fi
git diff --cached --stat
git commit -m "Add VOCO Korea website pages and assets"
git push origin HEAD
echo 'Upload complete: https://github.com/syj133114/VOCOKOrea'
