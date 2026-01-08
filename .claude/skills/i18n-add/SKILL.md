---
name: i18n-add
description: 다국어 문자열을 ARB 파일에 자동으로 추가합니다. 새로운 UI 텍스트, 에러 메시지, 라벨 추가 시 사용하세요.
allowed-tools: Read, Edit, Bash(flutter:gen-l10n)
---

# i18n Add Skill

다국어 문자열을 `lib/l10n/*.arb`에 추가합니다.

## 지원 언어

- 🇰🇷 한국어 (`app_ko.arb`)
- 🇺🇸 영어 (`app_en.arb`)
- 🇯🇵 일본어 (`app_ja.arb`)

## 워크플로우

1. **정보 수집**: 키, 한국어, 영어, 일본어, 설명
2. **ARB 파일 업데이트**: 3개 파일에 추가
3. **코드 생성**: `flutter gen-l10n`
4. **사용법 안내**: `l10n.{key_name}`

## 키 명명 규칙

`{feature}_{context}` 형식

- `auth_login` - 인증/로그인
- `common_save` - 공통/저장
- `error_network` - 에러/네트워크

## ARB 형식

### 기본

```json
{
  "key_name": "번역 텍스트",
  "@key_name": {
    "description": "설명"
  }
}
```

### 플레이스홀더

```json
{
  "welcome_message": "{name}님, 환영합니다!",
  "@welcome_message": {
    "description": "환영 메시지",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "홍길동"
      }
    }
  }
}
```

사용: `l10n.welcome_message('홍길동')`

### 복수형 (영어)

```json
{
  "item_count": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@item_count": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

## 기존 Prefix

- `common_` - 공통
- `auth_` - 인증
- `error_` - 에러
- `announcement_` - 공지사항
- `qna_` - Q&A
- `notification_` - 알림
- `settings_` - 설정
- `group_` - 그룹
