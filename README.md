# ji-project-template

JRI 정책연구 프로젝트의 **공통 폴더 구조**와 **연구계획서(research_plan.docx) 템플릿**을 단일 출처로 관리.

신규 과제 착수 시 이 저장소를 참조해 표준화된 작업 폴더를 빠르게 셋업하는 것이 목적.

> 보고서 본문의 톤·서식·인용 표준은 별도 저장소 [`ji-report-standards`](https://github.com/z0nam/ji-report-standards)를 참조.

## 구조

```
ji-project-template/
├── docs/
│   ├── folder-structure.md              표준 폴더 구조 명세
│   ├── report-workflow.md               보고서 단계별 포맷(md→docx→gdoc→hwp) + AI 도구별 제약
│   └── research-design-review.md        연구설계심의 양식·작성요령 표준 등록 (Drive fileId)
├── scripts/
│   ├── init_project.sh                  신규 과제 폴더 생성 스크립트
│   └── fetch_jri_templates.sh           gdown으로 공통 바이너리 양식 일괄 다운로드
├── templates/
│   ├── research_plan.docx               연구계획서 원본 템플릿 (단순화 사본)
│   ├── claude-settings.json.template    Claude Code 보편 설정 템플릿
│   ├── report-tone-guideline.md.template 보고서 톤 가이드 stub (외부 표준 저장소 링크)
│   ├── payment-request/                 자문비·발표비 지급요청서(개인 지급 정보) 서식 + 채움 안내
│   └── common/                          (gitignored) fetch_jri_templates.sh 캐시 — hwp/hwpx/pdf 양식
├── examples/
│   ├── 지속가능지표/                       자매 과제 작업 폴더 가이드 사본 + 90번 지침 인덱스
│   └── 서귀포/                            자매 과제 90번 지침 인덱스
└── README.md
```

## 신규 과제 시작 동선

### 0. 최초 1회 (저장소 자체 셋업)

공통 바이너리 양식(hwp/hwpx/pdf) 캐시를 한 번 받아둠. 이후 모든 신규 과제가 이 캐시를 재사용.

```bash
pip install gdown   # 또는 pipx install gdown
~/dev/ji-project-template/scripts/fetch_jri_templates.sh
```

→ `templates/common/research-design/`(5개), `templates/common/report/`(3개)에 받아짐. gitignored.

### 1. 과제 폴더 생성

**(a) 과제명 결정**: `YYYYMMDD_구분_과제명` (구분 = `정책`/`전략`/`기반`/`미래기획` 등)

**(b) Drive 동기화된 `_2026/01.JRI_PM/` 경로에 init 실행**:

```bash
~/dev/ji-project-template/scripts/init_project.sh \
  "/path/to/Drive/_2026/01.JRI_PM" \
  "20260601_정책_아트페스타인제주경제효과"
```

자동 생성되는 것:

```
20260601_정책_아트페스타인제주경제효과/
├── 00.RFP/
├── 01.code/
├── 10.연구설계심의/
│   ├── research_plan.docx                       ← 간이 템플릿
│   ├── 연구설계심의_서식_최종(260401).hwp        ← 공식 양식
│   └── _가이드/
│       ├── 참고1. 연구설계심의 서식 작성요령.hwpx/docx/pdf
│       └── [참고]timeline - 2026-정책-ooo-과제명.xlsx
├── 20.회의/
├── 30.data/
├── 50.중간보고/
├── 80.행정/
├── 90.최종보고서/
│   └── 지침/
│       ├── 연구보고서_서식.hwpx
│       ├── 250624_인용표기방법.pdf
│       └── 250624_인용표기방법.hwp
└── 99.Reference/
```

### 2. 연구설계심의 단계 (착수 ~ 2월)

1. `00.RFP/`에 발주처 RFP/제안서 원본 배치 (수정 금지)
2. `10.연구설계심의/_가이드/`의 작성요령 docx를 펴고 [`docs/research-design-review.md`](docs/research-design-review.md)의 표준 8단원 구조 따라 md로 초안 작성 (클로드/Codex 협업)
3. 심의 제출 단계에서 `연구설계심의_서식_최종(260401).hwp`을 한글에서 열고 본문 옮겨 hwp로 제출
4. (선택) 과제 폴더에 Claude Code 활성화하려면:
   ```bash
   mkdir .claude
   cp ~/dev/ji-project-template/templates/claude-settings.json.template .claude/settings.json
   ```
5. (선택) 분석 코드 필요하면 `01.code/`에서 `git init` (별도 GitHub 저장소로 분리 가능, 서귀포 과제 사례 참조)

### 3. 본문 작성 단계 (중간보고 → 최종보고)

1. **본문 초안**: md로 작성 → docx로 변환하면서 `90.최종보고서/지침/연구보고서_서식.hwpx` 구조에 맞춤
2. **인용 표기**: `250624_인용표기방법.pdf` 규칙 따라 정리
3. **톤 가이드**: `templates/report-tone-guideline.md.template`을 새 과제 `90.최종보고서/지침/`에 복사. 외부 표준 저장소 raw URL을 통해 AI가 톤 가이드 참조 가능
4. **gdoc 협업 → hwp 최종**: md → 새 gdoc 생성(클로드) → 코멘트·수정(Codex) → hwp 최종(한글). 도구별 제약은 [`docs/report-workflow.md`](docs/report-workflow.md) 참조

## 폴더 구조 표준

자세한 의미와 사용 규칙은 [`docs/folder-structure.md`](docs/folder-structure.md) 참조.

요지:
- **넘버링은 10단위.** 1단위로 늘리면 사이에 끼워넣기 어려워 유지보수가 힘듦.
- **00, 99는 양 끝의 고정 슬롯.** 00.RFP는 원본 발주 자료, 99.Reference는 참조문헌.
- **01.code는 분석 코드 전용.** Git으로 관리되는 분석/스크립트만 둠.
- **선택적 슬롯**: 40번대(특수 분석, 예: RIO), 91.보도자료 등은 과제 성격에 따라 추가.

## 폴더 넘버링 운영 원칙

| 번호 | 슬롯 | 비고 |
|---|---|---|
| 00 | RFP | 양 끝 고정 |
| 01 | code | 분석 코드 |
| 10 | 연구설계심의 | research_plan, IRB 등 |
| 20 | 회의 | 회의록, 자문, 간담회 |
| 30 | data / 핵심문서 | 1차 자료, 통계 |
| 40 | (선택) 특수 분석 | RIO, 모형, 시뮬레이션 |
| 50 | 중간보고 | 중간보고서, 발표자료 |
| 60–70 | (예비) | 필요 시 사용 |
| 80 | 행정 | 계약, 정산, 공문 |
| 90 | 최종보고서 | 최종본, 출판 |
| 91 | (선택) 보도자료 | 언론 자료 |
| 99 | Reference | 참조문헌, 선행연구 |

## 참고 예시

`examples/지속가능지표/`에 2026년 자매 과제(`20260102_정책_지속가능지표평가체계개선`)에서 가져온 작업 폴더 가이드 사본이 있다 (`README.md`, `할일.md`). 신규 과제 README/할일 문서 작성 시 구조 참고용. 출처 메모는 `examples/지속가능지표/_출처.md` 참조.

`templates/claude-settings.json.template`는 자매 과제 `.claude/settings.json`에 들어 있던 보편 설정의 사본. 신규 과제에서 Claude Code를 쓸 때 `.claude/settings.json`으로 배치하면 됨.

`templates/report-tone-guideline.md.template`는 자매 과제 `90.최종보고서/지침/`에 들어 있던 보고서 톤·서식·인용 표기 가이드의 stub. 본문은 외부 표준 저장소 [`z0nam/ji-report-standards`](https://github.com/z0nam/ji-report-standards)에서 중앙 관리되며, 본 파일은 raw URL 인덱스 역할만 한다. 신규 과제 `90.최종보고서/지침/`에 `report_tone_guideline_<날짜>.md`로 배치하면 됨.

`templates/payment-request/`는 자문·발표·간담회 등에서 외부 위원에게 자문비를 지급할 때 자문위원에게 받아 채우는 개인 지급 정보 서식(hwp). hwp-agent form fill로 자동 채워지는 라벨 슬롯(성명·소속·핸드폰·계좌 등)과 자유 텍스트 필드(회의 기간·건명·금액·서명 날짜) 안내가 [`templates/payment-request/README.md`](templates/payment-request/README.md)에 정리되어 있다. XML 텍스트 치환 파이썬 예시도 포함.

JRI 공통 `연구보고서_서식.hwpx`(한글 보고서 서식), `250624_인용표기방법.pdf`(인용 지침) 같은 큰 바이너리는 인라인 복사 대신 `examples/*/​_출처.md`에 Drive fileId를 인덱싱했다. 필요 시 Drive에서 직접 받아 신규 과제 `90.최종보고서/지침/`에 배치.

연구설계심의 단계의 공식 hwp 양식과 작성요령(docx/pdf/hwpx) 역시 바이너리라 fileId만 인덱싱. 표준 목차 요약과 fileId 표는 [`docs/research-design-review.md`](docs/research-design-review.md) 참조. 본 저장소의 `templates/research_plan.docx`는 이 양식의 단순화된 사본이다 — 빠른 착수용이며 정식 심의 제출은 공식 hwp 양식 사용.

## 변경 절차

- 폴더 구조나 템플릿을 바꿀 때는 PR로 제안.
- 자매 프로젝트에서 자주 등장하는 새 슬롯이 있다면 `docs/folder-structure.md`에 추가하고 표 업데이트.
