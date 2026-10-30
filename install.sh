#!/usr/bin/env bash
# 작업 폴더에서 실행: bash ~/codex-kit/install.sh
# 1) 이 저장소의 스킬  2) 공개 스킬 2개(obra/superpowers)  3) AGENTS.md(없을 때만)
set -u
KIT="$(cd "$(dirname "$0")" && pwd)"
DEST="${CODEX_HOME:-$HOME/.codex}/skills"
mkdir -p "$DEST"
cp -r "$KIT"/skills/* "$DEST"/

TMP="$(mktemp -d)"
if git clone -q --depth 1 https://github.com/obra/superpowers.git "$TMP/superpowers"; then
  cp -r "$TMP/superpowers/skills/verification-before-completion" "$TMP/superpowers/skills/systematic-debugging" "$DEST"/
else
  echo "superpowers를 받지 못했어요. 이 저장소의 스킬만 설치했어요."
fi
rm -rf "$TMP"

if [ ! -e AGENTS.md ]; then
  cp "$KIT/AGENTS.md" ./AGENTS.md && echo "AGENTS.md를 작업 폴더에 복사했어요."
else
  echo "작업 폴더에 AGENTS.md가 이미 있어서 건드리지 않았어요."
fi

echo "설치된 스킬 ($DEST):"
ls "$DEST"
echo "Codex를 /quit 으로 닫고 다시 켜세요."
