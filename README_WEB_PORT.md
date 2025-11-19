# 웹 개발 포트 설정

이 프로젝트는 로컬 웹 개발 시 **포트 3001**을 사용합니다.

## 실행 방법

### VS Code에서 실행 (권장)

1. **F5** 키를 누르거나 상단 메뉴에서 **Run > Start Debugging**
2. 실행 구성 선택:
   - `family_planner (Web - Chrome)` - Chrome에서 실행
   - `family_planner (Web - Edge)` - Edge에서 실행

자동으로 `http://localhost:3001`에서 실행됩니다.

### 커맨드 라인에서 실행

```bash
# Chrome에서 실행
flutter run -d chrome --web-port=3001

# Edge에서 실행
flutter run -d edge --web-port=3001

# 프로필 모드
flutter run --profile --web-port=3001

# 릴리즈 모드
flutter run --release --web-port=3001
```

## 포트 충돌 해결

포트 3001이 이미 사용 중일 경우:

### Windows
```powershell
# 포트 3001을 사용하는 프로세스 확인
netstat -ano | findstr :3001

# 프로세스 종료 (PID 확인 후)
taskkill /PID <PID> /F
```

### Linux/macOS
```bash
# 포트 3001을 사용하는 프로세스 확인
lsof -i :3001

# 프로세스 종료
kill -9 <PID>
```

## 포트 변경

다른 포트를 사용하려면:

1. `.vscode/launch.json` 파일의 `--web-port=3001` 수정
2. `.vscode/settings.json` 파일의 `--web-port=3001` 수정

## 백엔드 서버 포트

- **백엔드 개발 서버**: `localhost:3000`
- **프론트엔드 웹 앱**: `localhost:3001`

이렇게 분리하여 포트 충돌을 방지합니다.

## 브라우저 자동 실행

VS Code에서 F5를 누르면 자동으로 브라우저가 열립니다.

수동으로 열려면:
```
http://localhost:3001
```
