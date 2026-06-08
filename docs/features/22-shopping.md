# 22. 장보기 (Shopping) 🟨

## 상태
🟨 진행 중 (~85% 완료)

---

## UI 구현
- ✅ 장보기 화면 (ShoppingScreen) — 그룹 선택 드롭다운 + 3탭 구조
  - **탭1: 장바구니** (CartTab)
    - 품목 목록 (체크박스로 구매 완료 표시, 완료 항목 취소선)
    - FAB(작은) — 품목 추가
    - FAB(큰) — 장보기 완료 (items > 0일 때만 표시)
    - 장보기 완료 폼 — DraggableScrollableSheet 풀스크린 바텀시트
      - Step1: 냉장고 이관 보관소 선택 + 항목 제외(excludes) 기능
      - Step2: 냉장고 이관 시 유통기한 추천 자동 적용, 금액 입력 제거
      - 가계부 등록 섹션: 소비처(merchant) 선택 포함
    - Android SafeArea 처리 (useSafeArea: true)
  - **탭2: 자주 사는 것** (FrequentItemsTab)
    - 항목별 autoAdd 토글 — 상단 '자동 추가' 라벨 표시, ON/OFF 색상 연동
    - 항목별 장바구니 추가 버튼
    - FAB — 항목 추가 (DraggableScrollableSheet 풀스크린 바텀시트)
    - 항목 추가/수정 폼: AlertDialog → DraggableScrollableSheet 변경
  - **탭3: 구매 이력** (ShoppingHistoryTab)
    - 카드형 목록 (날짜, 품목 수, 총 금액, 가계부 연결 뱃지)
    - 페이지네이션 (더 보기 버튼)
    - 카드 탭 → 구매 이력 상세 화면

- ✅ 구매 이력 상세 화면 (ShoppingHistoryDetailScreen)
  - 날짜, 가계부 금액 카드 (가계부 보기 버튼 → 가계부 상세 이동)
  - 품목 목록
    - 냉장고 이관 여부: leading 아이콘 + 툴팁 (trailing 체크 아이콘 제거)
    - 가격 null 처리: '가격 미입력' 옅은 회색 표시
    - 개별 항목 장바구니 담기 버튼 (가격 포함)
  - 하단 고정 '이 리스트 그대로 장바구니에 담기' 버튼 (가격 포함)
  - 삭제 확인 다이얼로그: 가계부/냉장고 데이터 유지 안내 문구 포함

## 다이얼로그 / 바텀시트
- ✅ 장바구니 품목 추가 바텀시트 — 이름, 수량, 단위, 메모
- ✅ 장보기 완료 바텀시트 (DraggableScrollableSheet)
  - Step1: 품목별 이관 보관소 선택, 항목 제외 체크박스, 아코디언 자동 닫힘
  - Step2: 유통기한 추천 자동 매칭, 금액 입력 없음, 날짜 필드 라벨링
  - 가계부 등록: 금액(읽기전용), 결제수단, 소비처(merchant) 선택
- ✅ 자주 사는 것 추가/수정 바텀시트 — 이름, 기본 단위, autoAdd 토글

## 데이터 모델
- ✅ CartItemModel, CartModel — `lib/features/main/fridge/data/models/fridge_models.dart`
- ✅ FrequentItemModel
- ✅ ShoppingHistoryModel, ShoppingHistoryItemModel, LinkedExpenseModel
- ✅ ShoppingHistoryPageModel (페이지네이션)
- ✅ CartItemEntryDto, CartItemUpdateEntryDto (name/unit 항상 전송)
- ✅ CompleteCartDto (excludes: List<String>? 포함)
- ✅ TransferItemDto, ShoppingExpenseDto (merchantId 포함)
- ✅ CreateFrequentItemDto, UpdateFrequentItemDto

## 기능 구현
- ✅ 장바구니 조회/품목 추가/수정/삭제
- ✅ 품목 체크/체크 해제 (낙관적 업데이트)
- ✅ pending 항목 디바운스 자동 동기화
- ✅ 완료 버튼 누를 때 pending flush 후 완료 폼 열기
- ✅ 장보기 완료 — excludes(제외 항목) 지원, 완료 후 서버 re-fetch로 UI 즉시 반영
- ✅ 냉장고 이관 — 유통기한 추천(ExpiryPresetModel 매칭), 아코디언 자동 닫힘
- ✅ 가계부 등록 — 소비처(merchant) 선택 포함
- ✅ 무한 로딩 버그 수정 (400 에러 시 finally → catch)
- ✅ 자주 사는 항목 CRUD + autoAdd 토글(라벨 표시) + 순서 변경
- ✅ 자주 사는 항목 → 장바구니 원터치 추가
- ✅ 구매 이력 목록 (페이지네이션)
- ✅ 구매 이력 상세 — 개별/전체 장바구니 다시 담기 (가격 포함)
- ✅ 구매 이력 삭제 확인 다이얼로그 (가계부/냉장고 데이터 유지 안내)
- ⬜ 소비처 샘플 목록에 코스트코 추가 (merchant_model.dart)

## API 연동
- ✅ `GET /shopping/cart` — 활성 장바구니 조회
- ✅ `PATCH /shopping/cart/items/bulk` — 품목 일괄 동기화 (name/unit 항상 전송)
- ✅ `POST /shopping/cart/complete` — 장보기 완료 (excludes, expense.merchantId 포함)
- ✅ `GET /shopping/history` — 이력 목록 (페이지네이션)
- ✅ `GET /shopping/history/:historyId` — 이력 상세
- ✅ `DELETE /shopping/history/:historyId` — 이력 삭제
- ✅ `GET /fridge/frequent-items` — 자주 사는 항목 목록
- ✅ `POST /fridge/frequent-items` — 항목 생성
- ✅ `PATCH /fridge/frequent-items/reorder` — 순서 변경
- ✅ `PATCH /fridge/frequent-items/:itemId` — 항목 수정 (autoAdd 포함)
- ✅ `DELETE /fridge/frequent-items/:itemId` — 항목 삭제

## 구현 위치
```
lib/features/main/shopping/
├── presentation/
│   ├── screens/
│   │   ├── shopping_screen.dart
│   │   ├── cart_tab.dart                        ← 장바구니 + 완료 폼 통합
│   │   ├── frequent_items_tab.dart
│   │   ├── shopping_history_tab.dart
│   │   └── shopping_history_detail_screen.dart
lib/features/main/fridge/
├── data/
│   ├── models/fridge_models.dart                ← CartItemUpdateEntryDto, CompleteCartDto, ShoppingExpenseDto
│   └── repositories/fridge_repository.dart
├── providers/fridge_provider.dart               ← complete() 서버 re-fetch
lib/features/main/household/
└── data/models/merchant_model.dart              ← kMerchantSamples (코스트코 포함)
```

## 연동 관계
- `fridgeSelectedGroupIdProvider` — 냉장고·장보기 공유 (동일 그룹 선택 유지)
- 장보기 완료 후 → `storagesWithItemsProvider.refresh()` + 서버 re-fetch로 카트 갱신
- 가계부 등록 옵션 활성 시 → LinkedExpense 생성 → 이력 상세에서 가계부로 이동 가능
- 수량 소진(냉장고) → 서버가 autoAdd 항목 자동 장바구니 등재 → cartProvider 갱신
- `expiryPresetsProvider` — 냉장고 이관 시 유통기한 자동 추천
- `merchantsProvider` — 소비처 목록 조회 (household 공유)
