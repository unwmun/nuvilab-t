# 대기질 정보 앱 (Air Quality App)

이 앱은 한국 공공데이터 포털의 대기오염정보 API를 활용하여 실시간 대기질 정보를 제공하는 Flutter 애플리케이션입니다.

## 주요 기능

- 시도별 실시간 대기질 정보 조회
- 미세먼지, 초미세먼지, 오존 등 다양한 대기오염 지표 표시
- 대기질 등급에 따른 시각적 표현

## 기술 스택

- **프레임워크**: Flutter
- **상태관리**: Riverpod
- **네트워크**: Dio
- **데이터 모델링**: Freezed, json_serializable
- **의존성 주입**: get_it, injectable
- **모니터링**: Firebase Crashlytics
- **푸시 알림**: Firebase Cloud Messaging
- **백그라운드 작업**: Workmanager

## 애플리케이션 구조

MVVM 아키텍처를 기반으로 구성되어 있습니다:

```
lib/
├── core/               # 공통 유틸리티, 의존성 주입 등
├── data/               # 데이터 소스, 모델, 저장소 구현
│   ├── models/         # Freezed 모델 정의
│   ├── datasources/    # API 통신 관련 클래스
│   ├── repositories/   # 저장소 구현체
├── domain/             # 비즈니스 로직
│   ├── repositories/   # 저장소 인터페이스
│   ├── usecases/       # 유스케이스
├── presentation/       # UI 계층
│   ├── pages/          # 화면 위젯
│   ├── viewmodels/     # 뷰모델 (상태 및 비즈니스 로직)
│   ├── widgets/        # 재사용 가능한 위젯
```

## 설치 및 실행

1. Flutter 개발 환경 설정

   ```
   flutter pub get
   ```

2. 코드 생성 실행

   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. 앱 실행
   ```
   flutter run
   ```

## 성능 최적화 및 모니터링

### Flutter DevTools 활용

이 프로젝트는 성능 최적화 및 디버깅을 위해 Flutter DevTools를 적극 활용합니다.

1. DevTools 실행하기

   ```bash
   flutter run -d chrome --web-renderer html
   # 콘솔에 표시되는 DevTools URL 접속 (일반적으로 http://127.0.0.1:9100/)
   ```

2. 성능 모니터링

   - **Performance 탭**: UI 렌더링 병목 현상 파악
   - **Memory 탭**: 메모리 누수 및 과도한 객체 할당 확인
   - **Network 탭**: API 호출 지연 및 응답 시간 파악

3. 최적화 유틸리티 사용

   ```dart
   // 위젯 빌드 성능 측정
   final performanceService = getIt<PerformanceService>();
   performanceService.trackBuildPerformance('MyWidgetName', myWidget);

   // 특정 작업 실행 시간 측정
   await performanceService.measureExecutionTime('데이터 로딩', () async {
     await repository.fetchData();
   });
   ```

4. 최적화된 위젯 사용
   ```dart
   OptimizedList<String>(
     items: myItems,
     itemBuilder: (context, item, index) => MyListItem(item: item),
   );
   ```

### Firebase Crashlytics

이 프로젝트는 Firebase Crashlytics를 통해 앱 크래시 및 오류를 모니터링합니다.

1. 사용자 정보 설정

   ```dart
   final crashlytics = getIt<CrashlyticsService>();
   crashlytics.setUserIdentifier('user-123');
   ```

2. 커스텀 에러 기록

   ```dart
   try {
     // 잠재적 오류 발생 코드
   } catch (e, stack) {
     crashlytics.recordError(e, stack);
   }
   ```

3. 이벤트 로깅

   ```dart
   crashlytics.log('사용자가 결제 프로세스 시작');
   crashlytics.setCustomKey('payment_method', 'credit_card');
   ```

4. Firebase 콘솔 확인
   - https://console.firebase.google.com 에서 프로젝트 선택 후 Crashlytics 섹션 확인

## 사용된 공공 API

- 대기오염정보 조회 서비스 (한국환경공단)
- 엔드포인트: `http://apis.data.go.kr/B552584/ArpltnInforInqireSvc`

## 라이센스

이 프로젝트는 MIT 라이센스로 배포됩니다.

## 테스트 실행하기

### 단위 테스트

```bash
flutter test
```

### 통합 테스트

통합 테스트는 실제 앱 환경에서 UI와 기능을 테스트합니다.

#### 모의 API 테스트 (권장)

실제 API 호출 없이 모의 데이터로 테스트합니다:

```bash
flutter test integration_test/app_mock_test.dart
```

#### 실제 API 테스트 (선택사항)

실제 API와 통신하면서 테스트합니다:

```bash
flutter test integration_test/app_test.dart
```

> **참고**: 실제 API 테스트는 인터넷 연결과 API 서버 상태에 따라 결과가 달라질 수 있습니다.

### 스크립트를 통한 모든 테스트 실행

```bash
# 실행 권한 부여
chmod +x integration_test/run_test.sh

# 테스트 실행
./integration_test/run_test.sh
```
