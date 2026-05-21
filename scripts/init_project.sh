#!/usr/bin/env bash
# init_project.sh — JRI 정책연구 과제 폴더를 표준 구조로 생성
#
# 사용법:
#   init_project.sh <대상_상위경로> <과제폴더명>
#
# 예시:
#   init_project.sh "/Users/me/.../01.JRI_PM" "20260601_정책_아트페스타인제주경제효과"
#
# 동작:
#   - 상위경로 아래에 과제폴더 생성 (이미 있으면 그 위에 표준 슬롯만 보강)
#   - 표준 폴더 슬롯 생성 (10단위)
#   - 10.연구설계심의/ 안에 research_plan.docx 템플릿 복사
#   - 기존에 같은 이름의 슬롯이 있으면 그대로 둠 (덮어쓰기 없음)

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <parent_dir> <project_name>" >&2
  exit 1
fi

PARENT="$1"
PROJECT="$2"
TARGET="$PARENT/$PROJECT"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DOCX="$REPO_ROOT/templates/research_plan.docx"

if [[ ! -d "$PARENT" ]]; then
  echo "ERROR: 상위경로가 없음: $PARENT" >&2
  exit 1
fi

mkdir -p "$TARGET"
cd "$TARGET"

# 표준 슬롯 — 10단위, 한글/영문 컨벤션은 자매폴더 빈도 기준
SLOTS=(
  "00.RFP"
  "01.code"
  "10.연구설계심의"
  "20.회의"
  "30.data"
  "50.중간보고"
  "80.행정"
  "90.최종보고서"
  "99.Reference"
)

for slot in "${SLOTS[@]}"; do
  if [[ -d "$slot" ]]; then
    echo "  skip: $slot (이미 존재)"
  else
    mkdir -p "$slot"
    echo "  create: $slot"
  fi
done

# research_plan.docx 템플릿 배치 (없을 때만)
DEST_DOCX="10.연구설계심의/research_plan.docx"
if [[ -f "$DEST_DOCX" ]]; then
  echo "  skip: $DEST_DOCX (이미 존재)"
elif [[ -f "$TEMPLATE_DOCX" ]]; then
  cp "$TEMPLATE_DOCX" "$DEST_DOCX"
  echo "  copy: $DEST_DOCX"
else
  echo "  warn: 템플릿이 없음: $TEMPLATE_DOCX" >&2
fi

# 공통 바이너리 양식 배치 (fetch_jri_templates.sh로 받은 캐시가 있을 때만)
COMMON_RD="$REPO_ROOT/templates/common/research-design"
COMMON_RP="$REPO_ROOT/templates/common/report"

if [[ -d "$COMMON_RD" ]] && [[ -n "$(ls -A "$COMMON_RD" 2>/dev/null)" ]]; then
  mkdir -p "10.연구설계심의/_가이드"
  for src in "$COMMON_RD"/*; do
    name=$(basename "$src")
    if [[ "$name" == "연구설계심의_서식_최종"* ]]; then
      dest="10.연구설계심의/$name"
    else
      dest="10.연구설계심의/_가이드/$name"
    fi
    if [[ -f "$dest" ]]; then
      echo "  skip: $dest (이미 존재)"
    else
      cp "$src" "$dest"
      echo "  copy: $dest"
    fi
  done
else
  echo "  info: templates/common/research-design 비어 있음 — scripts/fetch_jri_templates.sh로 받기"
fi

if [[ -d "$COMMON_RP" ]] && [[ -n "$(ls -A "$COMMON_RP" 2>/dev/null)" ]]; then
  mkdir -p "90.최종보고서/지침"
  for src in "$COMMON_RP"/*; do
    name=$(basename "$src")
    dest="90.최종보고서/지침/$name"
    if [[ -f "$dest" ]]; then
      echo "  skip: $dest (이미 존재)"
    else
      cp "$src" "$dest"
      echo "  copy: $dest"
    fi
  done
else
  echo "  info: templates/common/report 비어 있음 — scripts/fetch_jri_templates.sh로 받기"
fi

echo ""
echo "완료: $TARGET"
