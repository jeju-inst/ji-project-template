# 지급요청서 서식 (payment-request)

자문·발표·간담회 등에서 외부 위원에게 자문비·발표비를 지급할 때 자문위원에게 받아 채우는 **개인 지급 정보** 양식.

## 파일

- `지급요청서양식.hwp` — 원본 hwp 서식 (98KB · classify=flat 이지만 label-based 슬롯 인식됨)

원출처: 자매 과제 `20260102_정책_지속가능지표평가체계개선/20.회의/20260602_지표자문/_지급요청서양식.hwp` 사본.

## 언제 쓰는가

- 자문회의 개최 후 자문위원 자문비 지급 정산
- 인터뷰 대상자에게 자문료 지급 (기타소득 원천징수)
- 발표자·간담회 참석자 발표비·수당 지급

같은 자리에서 지급기안(회의비 신청)과 함께 처리되는 게 통상. 지급기안은 원내 결재 라인용, 지급요청서는 **개인 지급 정보 수집**용.

## 채워야 할 정보

### hwp-agent form fill 로 자동 채워지는 슬롯 (label-based)

hwp를 hwpx로 변환한 뒤 `hwp-agent form fill --set "라벨=값"` 로 채워짐. 라벨 문자열의 공백 개수까지 정확히 일치시켜야 인식됨:

| 슬롯 | 라벨 (공백 유의) | 기입 방향 | 비고 |
|---|---|---|---|
| 성명 | `성  명` (공백 2) | right | |
| 소속 | `소  속` (공백 2) | right | |
| 핸드폰 | `핸드폰` | right | |
| 주소 | `주  소` (공백 2) | right | (2개 슬롯) |
| 사무실 | `사무실` | right | 전화번호 |
| 은행명 | `은행명` | right | |
| 계좌번호 | `계좌번호` | right | |
| E-mail | `E-mail` | right | |
| 주민번호 앞 | `주민등록번호` | below | 앞 6자리 |
| 주민번호 뒤 | `주민등록번호` | right | 뒤 7자리 |
| 동의 (동의함) | `checkbox:?` | — | on/off |
| 동의 (미동의) | `checkbox:동의하지` | — | on/off |

**자동 채우기 예시 (성명·소속·핸드폰만 · 실제 26P25 사례)**:

```bash
# 먼저 hwp → hwpx 변환
hwp-agent convert 지급요청서양식.hwp 지급요청서양식.hwpx

# form fill (라벨 공백 정확히 맞출 것)
hwp-agent form fill 지급요청서양식.hwpx \
  --set "성  명=홍길동" \
  --set "소  속=제주대학교병원" \
  --set "핸드폰=010-XXXX-XXXX" \
  -o 26PXX_지급요청서_홍길동.hwpx
```

**주민번호·계좌번호는 인터뷰 당일 자문위원 대면 확보 후 채우는 게 관행.** 자동 채우기 시에는 성명·소속·연락처 정도만 미리 넣고, 개인 민감정보는 당일 한글에서 편집.

### form fill 로 안 되는 자유 텍스트 필드

label-based 슬롯이 없어 form fill 대상이 아님. **한글에서 직접 편집**하거나 **XML 텍스트 치환** 필요:

| 필드 | 원본 값 예시 (이전 과제 잔재) | 새 과제 값으로 교체 필요 |
|---|---|---|
| 상단 회의 기간 날짜 | `2026년 6월  5일 ~  6월   5일( 1일간)` | ★ 반드시 새 회의 기간으로 |
| 건명 | `건명 : 「제주 지속가능발전 평가시스템 개선 연구」 연구설계심의 자문 (서면)` | ★ 반드시 새 과제명·자문 내용으로 |
| 자문비 금액 | `₩200,000원` | ★ 반드시 새 금액으로 (원천징수 前 총액) |
| 하단 신청인 서명 날짜 | `2026년 6월 5일 신청인 (서명)` | ★ 반드시 새 서명일로 |
| 서명·인 | 공란 | 인터뷰 당일 자필·전자서명 |

⚠️ **원본 hwp에는 이전 과제(지속가능지표) 정보가 남아있으니 서식 재사용 시 위 4개 필드는 반드시 새 과제 정보로 교체할 것.** 개인 지급 정보(성명·계좌 등)는 원본에 비어있음.

### XML 텍스트 치환 예시 (Python)

form fill로 안 되는 필드는 hwpx 내부 XML의 텍스트 노드를 치환하면 자동화 가능. 26P25 아트페스타 세션에서 실제로 사용한 패턴:

```python
import re
import zipfile
from pathlib import Path

SRC = Path("26PXX_지급요청서_홍길동.hwpx")
DST = SRC  # 덮어쓰기

REPLACEMENTS = [
    # 상단 회의 기간
    ("2026년 6월  5일 ~  6월   5일( 1일간)",
     "2026년 8월 26일 ~ 8월 26일( 1일간)"),
    # 건명
    ("「제주 지속가능발전 평가시스템 개선 연구」 연구설계심의 자문 (서면)",
     "「신 과제명」 ..."),
    # 하단 신청인 서명 날짜 (년도는 별도 run이라 월·일만 교체)
    ("   6월     5일  신청인                   (서명) ",
     "   8월    26일  신청인                   (서명) "),
    # 금액
    ("₩200,000원", "₩150,000원"),
]

# ZIP 컨테이너 보존 — 원 infolist 순서·ZipInfo 유지 (한글의 "높음" 보안 모드에서 열리게)
with zipfile.ZipFile(SRC, "r") as zin:
    infos = zin.infolist()
    payloads = {info.filename: zin.read(info.filename) for info in infos}

target = "Contents/section0.xml"
xml = payloads[target].decode("utf-8")
patched = xml
for old, new in REPLACEMENTS:
    if old in patched:
        patched = patched.replace(old, new)

# linesegarray 제거 — 텍스트 길이 변경으로 lineseg 캐시가 깨져 렌더링 오류(줄바꿈 겹침) 발생 방지
patched = re.sub(r"<hp:linesegarray>.*?</hp:linesegarray>", "", patched, flags=re.S)
patched = re.sub(r"<hp:linesegarray\s*/>", "", patched)

payloads[target] = patched.encode("utf-8")

with zipfile.ZipFile(DST, "w") as zout:
    for info in infos:
        # writestr(info, data) — 원 압축 방식·엔트리 순서 유지
        zout.writestr(info, payloads[info.filename])
```

핵심 유의사항 (hwp-agent skill 지침 준거):
1. **ZIP 컨테이너 보존**: `ZipFile('w', ZIP_DEFLATED)` + 새 `writestr(name, ...)` 로 재작성하면 한글이 외부 변조로 오인하여 보안 경고. 반드시 원 `ZipInfo` 재사용.
2. **linesegarray 제거**: 텍스트를 바꾸면 캐시된 줄 나눔 정보가 어긋나서 렌더링 시 여러 줄이 같은 좌표에 겹쳐 그려짐. 문서 전체에서 제거하면 한글이 열 때 다시 계산.
3. **텍스트 매칭**: 여러 run으로 쪼개진 텍스트는 replace 대상이 안 됨. hwp-agent extract or grep으로 원본 텍스트가 단일 노드인지 미리 확인.

## 관련 서식

- **지급기안 (회의비 신청)** — 별도 서식. 원내 결재 라인·회계 처리용. 26P25 세션에서는 `26P16` 과제의 `기안2_자문비지급_회의비신청.hwpx` 사본으로 처리했으며, 해당 서식은 slot 인식이 안 되는 자유 텍스트 서술형이라 한글 편집 필요.
- **자문회의 개최계획 기안** — `기안1_자문회의개최계획.hwpx`. GW 결재 상신용.

## 원천징수 참고

자문료·발표비는 통상 **기타소득**으로 원천징수 처리:
- 소득세 8% + 지방소득세 0.8% = **8.8%**
- 예: 지급액 150,000원 → 원천징수 13,200원 → 실지급 136,800원

정확한 세율·처리 방법은 원내 회계팀 기준 확인. 사업소득으로 지급하는 경우 3.3% 원천징수.

## 이력

- 2026-08-26 초기 등록 (26P25 아트페스타인제주 경제효과 분석 과제 자문비 지급 처리 중 서식 표준화 필요성 확인)
