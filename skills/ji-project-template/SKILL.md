---
name: ji-project-template
description: >-
  Set up standardized project folders and templates for JRI policy research projects.
  Use when asked to initialize a new research project folder ("새 과제 폴더 만들어줘",
  "과제 폴더 셋업"), provide or copy research proposal / review form templates ("연구계획서 틀",
  "연구설계심의 서식"), or locate payment request forms ("자문비 지급요청서").
---

# JRI Research Project Template (`ji-project-template`)

Provides the standard project folder structure (10-unit numbered slots) and standard document templates (research design review, research plan docx, payment request forms) for policy research at Jeju Research Institute (JRI).

## Standard Project Directory Slots

A standard research project folder follows this slot layout:

```
<project_name>/
├── 00.RFP/                 # 발주처 RFP/수요조사서 (기본). 내부과제면 00.과제기획
├── 01.code/                # 데이터 분석 코드 / GitHub 연동
├── 10.연구설계심의/         # 연구설계심의 서식(hwp), research_plan.docx, _가이드/
├── 20.회의/                # 자문회의, 착수/중간/최종 회의록
├── 30.data/                # 원천 데이터 및 정제 데이터
├── 50.중간보고/             # 중간보고회 발표자료 및 보고서
├── 80.행정/                # 과제 행정 문서, 자문비/발표비 지급요청서
├── 90.최종보고서/           # 최종보고서 원고 및 서식/인용 지침
└── 99.Reference/           # 관련 문헌 및 참고자료
```

## Quick Start: Initializing a New Project Folder

When a user asks to set up a new project folder (e.g. "새 과제 폴더 만들어줘", "과제 폴더 생성"):

1. **Determine project naming and parent directory:**
   - Standard folder naming: `YYYYMMDD_구분_과제명` (e.g., `20260601_정책_아트페스타인제주경제효과`, `20260601_미래기획_생산성플랫폼`)
   - Category (`구분`): `정책`, `전략`, `기반`, `미래기획`, `현안`, 등
   - Target parent directory: Usually located under the synchronized Google Drive directory (e.g. `_2026/01.JRI_PM/`).

2. **Run `init_project.sh`:**
   Execute the initialization script located in the repository `scripts/` directory:

   ```bash
   # Standard commissioned research (default: creates 00.RFP)
   bash path/to/ji-project-template/scripts/init_project.sh \
     "<parent_dir>" \
     "<project_folder_name>"

   # Internal / planning research without external client (creates 00.과제기획)
   bash path/to/ji-project-template/scripts/init_project.sh --type 내부 \
     "<parent_dir>" \
     "<project_folder_name>"
   ```

   - The script creates missing slot folders without overwriting existing files.
   - Automatically copies `research_plan.docx` to `10.연구설계심의/` if available.
   - If common binary templates have been cached (via `fetch_jri_templates.sh`), copies them to `10.연구설계심의/` and `90.최종보고서/지침/`.

## Working with Standard Templates

### 1. Research Proposal / Design Review (`10.연구설계심의/`)

When asked for a research plan outline ("연구계획서 틀", "연구설계심의 양식"):

- **Simplified template**: `templates/research_plan.docx` (can be copied into the project's `10.연구설계심의/` folder).
- **Official Hangul format**:
  - `연구설계심의_서식_최종(260401).hwp`
  - Writing guide: `참고1. 연구설계심의 서식 작성요령.hwpx` (or `.docx`, `.pdf`)
  - Timeline template: `[참고]timeline - 2026-정책-ooo-과제명.xlsx`
- **Recommended authoring flow**:
  1. Draft the content in Markdown following the 8 standard sections (see `docs/research-design-review.md` in the repository):
     - 1. 연구의 필요성 및 목적
     - 2. 국내외 연구동향
     - 3. 연구 내용 및 범위
     - 4. 연구방법
     - 5. 기대효과 및 활용방안
     - 6. 연구 추진 일정
     - 7. 연구진 구성
     - 8. 주요 선행연구와의 차별성
  2. Final submission should be placed in `10.연구설계심의/` formatted in HWP/HWPX.

### 2. Common Binary Templates Download (`scripts/fetch_jri_templates.sh`)

If the common templates (`templates/common/`) are empty and need to be pulled from Google Drive:

```bash
# Requires gdown (pip install gdown / pipx install gdown)
bash path/to/ji-project-template/scripts/fetch_jri_templates.sh
```

Downloads:
- `research-design`: Official HWP form, guideline HWPX/DOCX/PDF, timeline XLSX
- `report`: `연구보고서_서식.hwpx`, citation guideline PDF/HWP

### 3. Payment Request Forms (`templates/payment-request/`)

When asked for advisor/speaker payment request forms ("자문비 지급요청서", "지급요청서 양식"):

- Template file: `templates/payment-request/지급요청서양식.hwp`
- Detailed guidance and required fields are documented in `templates/payment-request/README.md`.
- Requires: Expert information (name, resident registration number, address, bank account, affiliation, title), payment category (advisory fee, manuscript fee, presentation fee), and bankbook/ID card copies.
