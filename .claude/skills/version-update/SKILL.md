---
name: version-update
description: 버전 업데이트를 수행합니다. pubspec.yaml 버전 수정, git 커밋 이력 분석, 앱스토어용 업데이트 내용과 패치노트 MD 파일 생성, 변경 기능 검증까지 통합 처리합니다. "버전 업데이트", "버전 올려줘", "릴리즈 준비", "v1.x.x 배포 준비" 등으로 트리거됩니다.
allowed-tools: Read, Write, Edit, Bash(git:*), Bash(grep:*), Bash(flutter:analyze), AskUserQuestion
---

# Version Update Skill

버전 업그레이드 요청 시 전 과정을 자동 처리합니다.

## 전체 워크플로우

1. **버전 입력 확인** → 2. **커밋 범위 분석** → 3. **pubspec.yaml 수정** → 4. **패치노트 생성** → 5. **기능 검증** → 6. **결과 보고**

---

## Step 1. 버전 정보 확인

사용자가 목표 버전을 명시하지 않았으면 질문:

```
"어떤 버전으로 올릴까요? (현재: X.X.X+N)"
예: 1.0.1, 1.1.0, 2.0.0
```

버전 타입 규칙:
- **patch** (1.0.0 → 1.0.1): 버그 수정, 소규모 개선
- **minor** (1.0.0 → 1.1.0): 새 기능 추가
- **major** (1.0.0 → 2.0.0): 대규모 변경, 하위 호환 불가

build number는 자동으로 +1 증가.

---

## Step 2. 커밋 범위 분석

### 이전 버전 커밋 탐색

```bash
# 이전 버전 태그 형식: vX.X.X (예: v1.0.0)
git log --oneline | grep -E "^[a-f0-9]+ v[0-9]+\.[0-9]+\.[0-9]+"
```

이전 버전 커밋을 찾으면:
```bash
git log {이전버전_해시}..HEAD --oneline
```

이전 버전 커밋이 없으면 (최초 버전):
```bash
git log --oneline
```
전체 커밋을 분석 대상으로 사용.

### 커밋 분류 기준

수집한 커밋 메시지를 아래 카테고리로 분류:

| 카테고리 | 키워드 예시 |
|----------|------------|
| ✨ 새 기능 | 개발, 추가, 구현, 기능, 화면, 위젯 |
| 🐛 버그 수정 | 수정, 에러, 해결, 오류, fix |
| 🔧 개선 | 변경, 최적화, 리팩토링, 분리, 개선 |
| 🔒 설정/보안 | 설정, 환경, config, 출시, 배포 준비 |

Merge 커밋, 빌드/CI 커밋은 제외.

---

## Step 3. pubspec.yaml 수정

파일 위치: `pubspec.yaml` (루트)

```yaml
# 수정 전
version: 1.0.0+1

# 수정 후 (예: 1.0.1로 업그레이드, build +1)
version: 1.0.1+2
```

수정 후 반드시 Read로 확인.

---

## Step 4. 패치노트 생성

### 저장 위치

```
docs/release/v{버전}.md
```

디렉토리가 없으면 생성.

### 패치노트 파일 형식 (웹페이지 에디터용)

```markdown
# 패밀리플래너 v{버전} 업데이트

> 출시일: YYYY-MM-DD

## 주요 변경사항

### ✨ 새로운 기능
- **기능명**: 상세 설명

### 🐛 버그 수정
- 수정된 문제 설명

### 🔧 개선사항
- 개선 내용 설명

---

## 앱스토어 업데이트 내용

> 아래 내용을 앱스토어(App Store Connect / Google Play Console) 업데이트 설명란에 붙여넣으세요.

```
[v{버전}] 업데이트

이번 업데이트에서는 다음 내용이 개선되었습니다.

■ 새로운 기능
• 기능 설명 1
• 기능 설명 2

■ 버그 수정
• 수정 내용 1

■ 개선사항
• 개선 내용 1
```

---

_이 파일은 version-update 스킬에 의해 자동 생성되었습니다._
```

### 앱스토어 작성 원칙
- 기술 용어 대신 사용자 관점 언어 사용 ("API 수정" → "정보가 더 빠르게 불러와집니다")
- 최대 5개 항목으로 압축 (App Store 4,000자 제한 고려)
- 한국어 기준으로 작성

---

## Step 5. 기능 검증

이번 버전에서 변경된 기능들을 대상으로 정적 검증 수행.

### 검증 항목

#### 5-1. Flutter 정적 분석
```bash
flutter analyze --no-fatal-infos 2>&1 | tail -20
```
error가 있으면 즉시 보고. warning은 목록화.

#### 5-2. 변경 파일 확인
```bash
git diff {이전버전_해시}..HEAD --name-only | grep "\.dart$"
```

변경된 dart 파일 목록 확인.

#### 5-3. 핵심 파일 존재 검증

이번 커밋에서 신규 기능이 추가된 경우, 해당 기능의 필수 파일 존재 여부 확인:
- Screen 파일 (`*_screen.dart`)
- Provider 파일 (`*_provider.dart` 또는 `*_provider.g.dart`)
- Repository 파일 (API 연동 기능의 경우)
- l10n 키 (새 문자열이 추가된 경우 `app_ko.arb` 확인)

#### 5-4. 라우트 등록 확인

신규 화면이 있으면:
```bash
grep -r "routeName\|GoRoute\|path:" lib/core/routes/
```
라우트에 등록되어 있는지 확인.

#### 5-5. import 오류 패턴 확인
```bash
grep -rn "import '\.\./" lib/features/ --include="*.dart" | head -20
```
상대경로 import가 있으면 경고 (절대경로 사용 원칙 위반).

---

## Step 6. 결과 보고

최종 보고 형식:

```
## ✅ 버전 업데이트 완료: v{이전} → v{새버전}

### 변경 파일
- pubspec.yaml: version {이전} → {새버전}
- docs/release/v{새버전}.md: 패치노트 생성

### 분석된 커밋 ({N}개)
- ✨ 새 기능 X건
- 🐛 버그 수정 Y건
- 🔧 개선 Z건

### 검증 결과
- Flutter 분석: ✅ 오류 없음 / ⚠️ warning N건 / ❌ 오류 N건
- 라우트 등록: ✅ / ⚠️ 미확인 항목
- import 규칙: ✅ / ⚠️ 위반 N건

### 주의사항 (있을 경우)
- [문제 설명 및 권장 조치]

### 다음 단계
1. docs/release/v{버전}.md 내용 확인 및 앱스토어 등록
2. git commit -m "v{버전}" 으로 버전 커밋 생성
3. flutter build ipa --release / flutter build appbundle --release
```

---

## 주의사항

- pubspec.yaml 수정 전 반드시 Read로 현재 버전 확인
- 패치노트 생성 전 `docs/release/` 디렉토리 존재 여부 확인
- flutter analyze는 시간이 걸릴 수 있음 — 완료까지 대기
- 검증에서 ❌ 오류 발견 시 버전 업데이트를 중단하고 사용자에게 보고
