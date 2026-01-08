---
name: code-review
description: CODE_STYLE.md 기준으로 Dart/Flutter 코드를 자동 리뷰합니다. 코드 작성 후 품질 검증, 컨벤션 준수 확인, 리팩토링 제안 시 사용하세요.
allowed-tools: Read, Grep, Bash(flutter:analyze)
---

# Code Review Skill

[CODE_STYLE.md](../../../CODE_STYLE.md) 기준으로 코드를 리뷰합니다.

## 검증 항목

1. **Import 규칙**: 절대 경로, 올바른 순서
2. **명명 규칙**: snake_case, PascalCase, camelCase
3. **위젯 구조**: const 생성자, build 분해
4. **상수 활용**: AppColors, AppSizes, Theme
5. **상태 관리**: Riverpod when() 패턴
6. **에러 처리**: try-catch, debugPrint
7. **문서화**: /// 주석
8. **폴더 구조**: Feature-First

## 리뷰 프로세스

1. **파일 읽기**
2. **각 항목 검증**
3. **리포트 생성** (✅통과 / ⚠️개선 / ❌수정필요)
4. **flutter analyze 실행**

## 리포트 형식

```markdown
# Code Review Report

**파일**: `lib/features/.../screen.dart`
**전체 평가**: ✅ 통과 / ⚠️ 개선 필요 / ❌ 수정 필요

## 주요 이슈

### ❌ 상수 활용 (Line 67, 89)
- 하드코딩된 색상/padding 값
- `Color(0xFF...)` → `AppColors.primary`
- `16.0` → `AppSizes.spaceM`

### ⚠️ 위젯 구조 (Line 45)
- build 메서드 120줄 (분해 권장)

## 요약
- ✅ 통과: 6/8
- ⚠️ 개선: 1/8
- ❌ 수정: 1/8
```

## 핵심 체크리스트

- [ ] Import 절대 경로 + 순서
- [ ] 파일명 snake_case
- [ ] const 생성자
- [ ] AppColors, AppSizes 사용
- [ ] Theme.of(context) 활용
- [ ] Provider when() 패턴
- [ ] debugPrint() (print 금지)
- [ ] /// 문서 주석

상세 예시: [EXAMPLES.md](EXAMPLES.md)
