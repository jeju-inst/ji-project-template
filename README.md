# ji-project-scaffold

JRI 정책연구 프로젝트의 **공통 폴더 구조**와 **연구계획서(research_plan.docx) 템플릿**을 단일 출처로 관리.

신규 과제 착수 시 이 저장소를 참조해 표준화된 작업 폴더를 빠르게 셋업하는 것이 목적.

> 보고서 본문의 톤·서식·인용 표준은 별도 저장소 [`ji-report-standards`](https://github.com/z0nam/ji-report-standards)를 참조.

## 구조

```
ji-project-scaffold/
├── docs/
│   └── folder-structure.md   표준 폴더 구조 명세
├── scripts/
│   └── init_project.sh       신규 과제 폴더 생성 스크립트
├── templates/
│   └── research_plan.docx    연구계획서 원본 템플릿
└── README.md
```

## 빠른 사용

신규 정책연구 과제 폴더를 표준 구조로 만들고 연구계획서 템플릿을 배치:

```bash
# 사용법: init_project.sh <대상_상위경로> <과제폴더명>
~/dev/ji-project-scaffold/scripts/init_project.sh \
  "/path/to/_2026/01.JRI_PM" \
  "20260601_정책_아트페스타인제주경제효과"
```

생성 결과:

```
20260601_정책_아트페스타인제주경제효과/
├── 00.RFP/
├── 01.code/
├── 10.연구설계심의/
│   └── research_plan.docx     ← templates/에서 복사됨
├── 20.회의/
├── 30.data/
├── 50.중간보고/
├── 80.행정/
├── 90.최종보고서/
└── 99.Reference/
```

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

## 변경 절차

- 폴더 구조나 템플릿을 바꿀 때는 PR로 제안.
- 자매 프로젝트에서 자주 등장하는 새 슬롯이 있다면 `docs/folder-structure.md`에 추가하고 표 업데이트.
