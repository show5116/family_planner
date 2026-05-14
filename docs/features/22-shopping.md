# 22. 장보기 (Shopping) 🟨

## 상태
🟨 진행 중

---

## UI 구현
- 🟨 장보기 화면 (ShoppingScreen) — 그룹 선택 드롭다운 + 3탭 구조
  - **탭1: 장바구니** (CartTab)
    - 품목 목록 (체크박스로 구매 완료 표시, 완료 항목 취소선)
    - FAB(작은) — 품목 추가
    - FAB(큰) — 장보기 완료 (items > 0일 때만 표시)
    - 장보기 완료 다이얼로그 — 냉장고 이관 보관소 선택 + 가계부 등록 토글
  - **탭2: 자주 사는 것** (FrequentItemsTab)
    - 항목별 autoAdd 토글 (소진 시 자동 장바구니 등재)
    - 항목별 장바구니 추가 버튼
    - FAB — 항목 추가
  - **탭3: 구매 이력** (ShoppingHistoryTab)
    - 카드형 목록 (날짜, 품목 수, 총 금액, 가계부 연결 뱃지)
    - 페이지네이션 (더 보기 버튼)
    - 카드 탭 → 구매 이력 상세 화면

- 🟨 구매 이력 상세 화면 (ShoppingHistoryDetailScreen)
  - 날짜, 가계부 금액 카드 (가계부 보기 버튼 → 가계부 상세 이동)
  - 품목 목록 (냉장고 이관 여부 아이콘)

## 다이얼로그
- 🟨 장바구니 품목 추가 다이얼로그 — 이름, 수량, 단위, 메모
- 🟨 장보기 완료 다이얼로그
  - 품목별 이관 보관소 선택 (없으면 이관 안 함)
  - 가계부 등록 토글 → 금액 입력, 메모, 결제 수단 선택
- 🟨 자주 사는 것 추가/수정 다이얼로그 — 이름, 기본 단위, autoAdd 토글

## 데이터 모델
- 🟨 CartItemModel, CartModel — `lib/features/main/fridge/data/models/fridge_models.dart`
- 🟨 FrequentItemModel
- 🟨 ShoppingHistoryModel, ShoppingHistoryItemModel, LinkedExpenseModel
- 🟨 ShoppingHistoryPageModel (페이지네이션)
- 🟨 AddCartItemDto, UpdateCartItemDto, CompleteCartDto
- 🟨 TransferItemDto, ShoppingExpenseDto
- 🟨 CreateFrequentItemDto, UpdateFrequentItemDto

## 기능 구현
- 🟨 장바구니 조회/품목 추가/수정/삭제
- 🟨 품목 체크/체크 해제
- 🟨 장보기 완료 — ShoppingHistory 저장 + 선택 품목 냉장고 이관 + 옵션 가계부 등록
- 🟨 자주 사는 항목 CRUD + autoAdd 토글 + 순서 변경
- 🟨 자주 사는 항목 → 장바구니 원터치 추가
- 🟨 구매 이력 목록 (페이지네이션)
- 🟨 구매 이력 상세 + 가계부 연결 이동
- 🟨 그룹 선택 — fridgeSelectedGroupIdProvider 공유

## API 연동
- 🟨 `GET /fridge/cart` — 활성 장바구니 조회
- 🟨 `POST /fridge/cart/items` — 품목 추가
- 🟨 `PATCH /fridge/cart/items/:itemId` — 품목 수정 (체크 포함)
- 🟨 `DELETE /fridge/cart/items/:itemId` — 품목 삭제
- 🟨 `POST /fridge/cart/complete` — 장보기 완료
- 🟨 `GET /fridge/frequent-items` — 자주 사는 항목 목록
- 🟨 `POST /fridge/frequent-items` — 항목 생성
- 🟨 `PATCH /fridge/frequent-items/reorder` — 순서 변경
- 🟨 `PATCH /fridge/frequent-items/:itemId` — 항목 수정 (autoAdd 포함)
- 🟨 `DELETE /fridge/frequent-items/:itemId` — 항목 삭제
- 🟨 `GET /fridge/shopping-history` — 이력 목록 (페이지네이션)
- 🟨 `GET /fridge/shopping-history/:historyId` — 이력 상세

## 구현 위치
```
lib/features/main/shopping/
├── presentation/
│   ├── screens/
│   │   ├── shopping_screen.dart              ← 메인 3탭 화면
│   │   ├── cart_tab.dart
│   │   ├── frequent_items_tab.dart
│   │   ├── shopping_history_tab.dart
│   │   └── shopping_history_detail_screen.dart
│   └── widgets/
│       ├── add_cart_item_dialog.dart
│       ├── complete_shopping_dialog.dart
│       └── frequent_item_form_dialog.dart
```
※ 데이터/레포/프로바이더는 `lib/features/main/fridge/`에서 공유

## 연동 관계
- `fridgeSelectedGroupIdProvider` — 냉장고·장보기 공유 (동일 그룹 선택 유지)
- 장보기 완료 후 → `storagesWithItemsProvider.refresh()` 호출 (냉장고 품목 갱신)
- 가계부 등록 옵션 활성 시 → LinkedExpense 생성 → 이력 상세에서 가계부로 이동 가능
- 수량 소진(냉장고) → 서버가 autoAdd 항목 자동 장바구니 등재 → cartProvider 갱신
