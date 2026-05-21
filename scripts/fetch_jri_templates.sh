#!/usr/bin/env bash
# fetch_jri_templates.sh — JRI 공통 표준 양식/지침 바이너리를 Google Drive에서 일괄 다운로드
#
# 받는 파일들은 hwp/hwpx/pdf/xlsx 등 0.5MB 안팎의 바이너리라 인라인 복사 불가.
# 이 저장소에는 fileId 목록만 두고, 이 스크립트로 로컬 templates/common/ 캐시에 받음.
# 받은 파일은 init_project.sh가 신규 과제 폴더로 자동 배치.
#
# 사전조건:
#   pip install gdown   (또는 pipx install gdown)
#   - 사용자 Drive 계정에서 해당 fileId에 접근 권한이 있어야 함
#   - 권한 거부되면 처음 한 번 브라우저 인증이 필요할 수 있음
#
# 사용법:
#   scripts/fetch_jri_templates.sh [target_dir]
#     target_dir 기본값: <repo>/templates/common/
#
# 동작:
#   - 이미 받은 파일은 건너뜀 (덮어쓰기 없음)
#   - 실패한 파일은 경고만 남기고 계속 진행

set -euo pipefail

if ! command -v gdown >/dev/null 2>&1; then
  echo "ERROR: gdown 미설치. 다음 중 하나로 설치:" >&2
  echo "  pip install gdown" >&2
  echo "  pipx install gdown" >&2
  echo "  brew install gdown   # (homebrew 패키지 있을 경우)" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="${1:-$REPO_ROOT/templates/common}"

mkdir -p "$TARGET/research-design"
mkdir -p "$TARGET/report"

FAILED=0

fetch() {
  local id="$1"
  local subdir="$2"
  local name="$3"
  local dest="$TARGET/$subdir/$name"

  if [[ -f "$dest" ]]; then
    echo "  skip: $subdir/$name (이미 존재)"
    return 0
  fi

  echo "  fetch: $subdir/$name"
  if gdown --quiet --fuzzy "https://drive.google.com/uc?id=$id" -O "$dest" 2>/dev/null; then
    return 0
  fi

  rm -f "$dest"
  echo "    WARN: 다운로드 실패 (권한 확인 필요). fileId=$id" >&2
  FAILED=$((FAILED + 1))
  return 0
}

echo "Target: $TARGET"
echo ""
echo "[연구설계심의 양식]"
fetch "1RVwywqlEHQv0iZBDgTf1Ke5f41QRakyc" "research-design" "연구설계심의_서식_최종(260401).hwp"
fetch "18NwUWwTMpU3APfIaoHH5KT_YJ_0ZWjmd" "research-design" "참고1. 연구설계심의 서식 작성요령.hwpx"
fetch "1JXMqs20YJEXFpH8tuR4FM46ju5EgZsBT" "research-design" "참고1. 연구설계심의 서식 작성요령.docx"
fetch "1rnXWyCJRj8s4V2Xz_aH9NboHggZI6YAW" "research-design" "참고1. 연구설계심의 서식 작성요령.pdf"
fetch "1ucS0rMQ0_qiW_qRgXJhwJZPKqcXaYwux" "research-design" "[참고]timeline - 2026-정책-ooo-과제명.xlsx"

echo ""
echo "[보고서 표준 서식 및 인용 지침]"
fetch "19UDXrXE_nB8z71nJJiix3t5ks5zlS2M-" "report" "연구보고서_서식.hwpx"
fetch "1z6gGYyRzDVMptZlujL1_lMw064t4gw8z" "report" "250624_인용표기방법.pdf"
fetch "11Ig7doyvkH-Cu_If8zfz4q1L-5tDar8V" "report" "250624_인용표기방법.hwp"

echo ""
if [[ $FAILED -gt 0 ]]; then
  echo "완료 (실패 $FAILED건). 실패 항목은 Drive에서 수동으로 받아 적절한 위치에 배치."
  echo "fileId 매핑은 docs/research-design-review.md, examples/*/_출처.md 참고."
else
  echo "완료. 모든 파일 다운로드 성공."
fi
