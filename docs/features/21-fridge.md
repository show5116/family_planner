# 21. 냉장고 관리 (Fridge Management) 🟨

## 상태
🟨 진행 중

---

## UI 구현
- 🟨 냉장고 관리 화면 (FridgeScreen) — 그룹 선택 드롭다운 + 단일 스크롤 목록
  - 보관소 섹션별 구분 (냉장/냉동/팬트리 아이콘)
  - 품목별 D-Day 뱃지 (D-3 이하 주황, D-Day·경과 빨강)
  - 수량 +/- 버튼 (0이 되면 서버가 자동 장바구니 등재)
  - FAB — 보관소 추가
  - 보관소별 + 버튼 — 품목 추가
  - 보관소 더보기 메뉴 — 수정 / 삭제
  - 품목 더보기 메뉴 — 수정 / 삭제

## 다이얼로그
- 🟨 보관소 생성/수정 다이얼로그 (StorageFormDialog) — 이름 + 타입(냉장/냉동/팬트리) SegmentedButton
- 🟨 품목 생성/수정 다이얼로그 (FridgeItemFormDialog) — 이름, 수량, 단위, 유통기한(DatePicker), 알림 슬라이더(1-14일), 메모

## 데이터 모델
- 🟨 StorageModel — `lib/features/main/fridge/data/models/fridge_models.dart`
- 🟨 FridgeItemModel (daysUntilExpiry 계산 포함)
- 🟨 StorageWithItemsModel (GET /fridge/items 응답)
- 🟨 CreateStorageDto, UpdateStorageDto
- 🟨 CreateFridgeItemDto, UpdateFridgeItemDto
- 🟨 enum StorageType { fridge, freezer, pantry }

## 기능 구현
- 🟨 보관소 목록+품목 동시 조회 (GET /fridge/items)
- 🟨 보관소 생성/수정/삭제/순서 변경
- 🟨 품목 생성/수정/삭제
- 🟨 수량 변경 — 0이 되면 서버가 자동으로 장바구니에 등재 (카트 provider invalidate)
- 🟨 그룹 선택 (개인/그룹) — fridgeSelectedGroupIdProvider 공유

## API 연동
- 🟨 `GET /fridge/storages` — 보관소 목록
- 🟨 `POST /fridge/storages` — 보관소 생성
- 🟨 `PATCH /fridge/storages/reorder` — 순서 변경
- 🟨 `PATCH /fridge/storages/:storageId` — 보관소 수정
- 🟨 `DELETE /fridge/storages/:storageId` — 보관소 삭제
- 🟨 `GET /fridge/items` — 보관소별 품목 목록
- 🟨 `POST /fridge/items` — 품목 등록
- 🟨 `PATCH /fridge/items/:itemId` — 품목 수정
- 🟨 `DELETE /fridge/items/:itemId` — 품목 삭제
- 🟨 `PATCH /fridge/items/:itemId/quantity` — 수량 변경 (소진 시 자동 카트 등재)

## 구현 위치
```
lib/features/main/fridge/
├── data/
│   ├── models/fridge_models.dart          ← StorageModel, FridgeItemModel 등
│   └── repositories/fridge_repository.dart
├── providers/fridge_provider.dart          ← storagesWithItemsProvider, fridgeSelectedGroupIdProvider
└── presentation/
    ├── screens/
    │   └── fridge_screen.dart             ← 단일 스크롤 목록 화면
    └── widgets/
        ├── storage_form_dialog.dart
        ├── fridge_item_form_dialog.dart
        └── fridge_item_tile.dart          ← D-Day 뱃지 + 수량 조절
```

## 연동 관계
- `fridgeSelectedGroupIdProvider` — 냉장고·장보기 공유 (동일 그룹 선택 유지)
- 수량 0 변경 → 서버가 장바구니 자동 등재 → cartProvider.invalidate() 호출
- 장보기 완료(cart/complete) 시 transfers → 냉장고에 품목 추가 → storagesWithItemsProvider.refresh()
