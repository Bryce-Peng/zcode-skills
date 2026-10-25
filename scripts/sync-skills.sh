#!/usr/bin/env bash
# 重建收藏夹：按 curation.tsv 从上游重建 imported-skills/skills/，
# 内容有变时 bump 补丁版本号。本地可跑；CI 里由 upstream-sync workflow 调用后开 PR。
# 上游路径重构会在此硬失败（MISSING），不做静默降级。
# 注意：插值变量一律加花括号——macOS bash 3.2 会把紧邻的多字节字符吞进变量名。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TSV="$ROOT/curation.tsv"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

repo_dir() { echo "$WORK/$(echo "$1" | tr '/' '_')"; }

rows=0
while IFS=$'\t' read -r repo subpath dest; do
  [[ -z "${repo// }" || "$repo" == \#* ]] && continue
  repo="${repo%%[[:space:]]*}"
  subpath="$(echo "$subpath" | tr -d '[:space:]')"
  dest="$(echo "$dest" | tr -d '[:space:]')"
  rows=$((rows + 1))
  [[ -d "$(repo_dir "$repo")" ]] || git clone --depth 1 --quiet "https://github.com/$repo" "$(repo_dir "$repo")"
  src="$(repo_dir "$repo")/$subpath"
  if [[ ! -d "$src" ]]; then
    echo "MISSING: ${repo}/${subpath}（上游路径重构？更新 curation.tsv 对应行）" >&2
    exit 1
  fi
  rm -rf "$ROOT/imported-skills/skills/${dest}"
  rsync -a --exclude 'agents' "${src}/" "$ROOT/imported-skills/skills/${dest}/"
  echo "ok: ${dest} ← ${repo}/${subpath}"
done < "$TSV"

actual=$(ls "$ROOT/imported-skills/skills" | wc -l | tr -d ' ')
if [[ "$actual" != "$rows" ]]; then
  echo "DRIFT: skills/ 实有 ${actual} 个目录，curation.tsv 声明 ${rows} 个——先人工核对再继续" >&2
  exit 1
fi

changed=$(git -C "$ROOT" status --porcelain -- imported-skills/skills || true)
if [[ -z "$changed" ]]; then
  echo "UP-TO-DATE（${rows} 个技能与上游一致）"
  exit 0
fi

bump() { # $1 = file；bump 第一处 "version": "x.y.z" 的补丁位
  local v minor patch
  v=$(grep -m1 -o '"version": *"[0-9]*\.[0-9]*\.[0-9]*"' "$1" | grep -o '[0-9][0-9.]*')
  minor="${v%.*}"; patch="${v##*.}"
  sed -i.bak "s/\"version\": *\"$v\"/\"version\": \"$minor.$((patch + 1))\"/" "$1"
  rm -f "$1.bak"
}
bump "$ROOT/imported-skills/.zcode-plugin/plugin.json"
bump "$ROOT/marketplace.json"
echo "CHANGED：已按上游重建并 bump 版本——提交即可触发更新链"
