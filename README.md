# Nuvilab - 공공 API 연동 Flutter 애플리케이션

본 프로젝트는 Flutter를 기반으로 공공데이터 API를 연동한 모바일 애플리케이션입니다. MVVM 아키텍처 패턴을 적용하여 유지보수성과 확장성을 고려하였습니다.

## 📱 프로젝트 실행 방법

### 필수 환경

- Flutter 3.x
- Dart 3.x
- Android Studio 또는 VS Code
- Flutter 및 Dart 플러그인 설치

### 실행 단계

1. 의존성 설치 및 코드 생성 파일 빌드

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

위 명령은 Freezed, json_serializable, injectable_generator, hive_generator 등의 코드 생성 라이브러리가 필요로 하는 자동 생성 파일들을 생성합니다.

2. 애플리케이션 실행

```bash
flutter run
```

## 🛠️ 기술 스택 및 아키텍처

### 적용 기술

- **프레임워크**: Flutter 3.x
- **상태관리**: Riverpod, flutter_riverpod
- **네트워크**: Dio
- **데이터 모델링**: Freezed, json_serializable
- **로컬 저장소**: Hive, hive_flutter
- **의존성 주입**: get_it, injectable
- **보안**: flutter_secure_storage
- **백그라운드 작업**: Workmanager
- **푸시 알림**: Firebase Cloud Messaging, firebase_messaging
- **모니터링**: Firebase Crashlytics
- **딥링크**: app_links

### MVVM 아키텍처 구현

아래 폴더 구조로 MVVM 아키텍처를 구현하였습니다:

```
lib/
├── core/               # 공통 유틸, 상수, 공통 위젯 등
│   ├── constants/      # 앱 상수 정의
│   ├── di/             # 의존성 주입 설정
│   ├── network/        # 네트워크 관련 공통 로직
│   ├── security/       # 보안 관련 기능
│   ├── services/       # 백그라운드 서비스 등
│   └── utils/          # 유틸리티 함수
├── data/               # 데이터 소스 (API, DB), 모델 정의
│   ├── models/         # Freezed 모델 정의
│   ├── datasources/    # API 및 로컬 데이터 소스 구현
│   └── repositories/   # 저장소 구현체
├── domain/             # 비즈니스 로직 및 엔티티 정의
│   ├── repositories/   # 추상화된 리포지토리 인터페이스
│   └── usecases/       # 유스케이스 (비즈니스 로직 캡슐화)
└── presentation/       # UI 계층 (View + ViewModel)
    ├── pages/          # 각 화면 단위의 페이지
    ├── viewmodels/     # 상태 및 로직 관리
    └── widgets/        # 공용 컴포넌트
```

각 계층의 역할:

- **Model**: 데이터 구조와 데이터 접근 로직 담당
- **View**: UI 컴포넌트 및 상태 표현 담당
- **ViewModel**: View와 Model 사이의 중재, 비즈니스 로직 캡슐화

## 🚀 성능 최적화 적용 사항

다음과 같은 성능 최적화를 적용하였습니다:

### UI 렌더링 최적화

- `const` 생성자 활용으로 불필요한 위젯 리빌드 방지
- Riverpod을 활용한 상태 변경 범위 최소화
- SliverList, ListView.builder 등 지연 로딩 위젯 활용

### 네트워크 성능 최적화

- Hive 기반 로컬 캐싱
- Dio 인터셉터를 활용한 네트워크 요청 최적화
- 연결 실패 시 자동 재시도 메커니즘 구현

### 메모리 관리

- Firebase Crashlytics를 활용한 메모리 누수 모니터링
- 이미지 메모리 최적화

## 🧪 Mock API 테스트 방법

테스트 환경에서는 http_mock_adapter 패키지를 활용하여 Mock API를 구현했습니다. 테스트 코드에서의 구현 예시는 다음과 같습니다:

```dart
// Mock API 설정 예시
final dio = Dio(BaseOptions(baseUrl: 'https://api.airkorea.or.kr/api/v1'));
final dioAdapter = DioAdapter(dio: dio);

// 특정 API 엔드포인트에 대한 Mock 응답 설정
dioAdapter.onGet(
  '/getCtprvnRltmMesureDnsty',
  (server) => server.reply(
    200,
    {
      'response': {
        'body': {
          'totalCount': 1,
          'items': [
            {
              'sidoName': '서울',
              'stationName': '중구',
              'pm10Value': '25',
              // ... 기타 필드
            }
          ]
        },
        'header': {'resultMsg': 'NORMAL_CODE', 'resultCode': '00'}
      }
    }
  ),
  queryParameters: {
    'sidoName': '서울',
    'pageNo': 1,
    'numOfRows': 100,
    'returnType': 'json',
    'serviceKey': 'test_service_key',
    'ver': '1.0',
  },
);
```

### Mock API 테스트 실행

다음 명령어로 Mock API 기반 테스트를 실행할 수 있습니다:

```bash
flutter test test/data/datasources/air_quality_api_test.dart
```

## 🔄 네트워크 연결 끊김 이슈 해결

### 이슈 설명

애플리케이션에서 네트워크 연결이 끊어질 경우 무한 로딩 상태가 발생하는 문제가 발견되었습니다. 사용자는 데이터 로딩 스피너만 보게 되어 앱이 응답이 없는 것처럼 느껴질 수 있었습니다.

### 원인 분석

1. **네트워크 상태 감지 불충분**: 기존 `NetworkInfo` 구현은 단순히 `InternetAddress.lookup()`을 사용하여 네트워크 연결을 확인했지만, 시간 초과 설정이 없었고 네트워크 상태 변화를 실시간으로 감지하지 못했습니다.

2. **오프라인 상태에서 UI 처리 미흡**: 네트워크 연결이 끊어진 상태를 사용자에게 명확히 표시하지 않았고, 로컬 캐시 데이터 사용 여부도 알려주지 않았습니다.

3. **타임아웃 처리 부족**: 네트워크 요청 시 타임아웃 설정은 있었지만, 연결이 끊어진 경우 무한정 대기하는 문제가 있었습니다.

### 구현된 해결책

#### 1. 개선된 네트워크 상태 감지

- `connectivity_plus` 패키지를 도입하여 기기의 연결 상태를 실시간으로 모니터링
- 네트워크 연결 확인에 타임아웃 추가 (5초)
- 연결 상태 변경 스트림을 제공하여 앱 전체에서 연결 상태 변화를 구독할 수 있도록 개선

```dart
Future<bool> get isConnected async {
  try {
    // 먼저 기기의 연결 상태 확인
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // 실제 인터넷 연결 확인
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 5));
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}
```

#### 2. 사용자 인터페이스 개선

- 오프라인 상태일 때 명확한 배너 표시
- 캐시된 데이터를 사용 중임을 사용자에게 알림
- 오프라인 모드에 맞는 특별한 에러 메시지 제공

#### 3. 연결 상태 변경 알림

- 네트워크 연결이 복구되거나 끊겼을 때 사용자에게 Snackbar로 알림
- 연결 복구 시 자동으로 최신 데이터 로드

### 재현 및 테스트 방법

다음 단계로 이슈를 재현하고 해결책을 테스트할 수 있습니다:

1. **이슈 재현 방법**:

   - 앱을 실행하고 데이터를 로드
   - 기기를 비행기 모드로 전환하거나 네트워크 연결 해제
   - 앱에서 새로고침 버튼 탭 또는 다른 시도 선택
   - 수정 전: 무한 로딩 상태 발생, 사용자에게 피드백 없음
   - 수정 후: 오프라인 모드 배너 표시, 캐시된 데이터가 있으면 표시, 없으면 적절한 오류 메시지 표시

2. **네트워크 복구 테스트**:

   - 앱이 오프라인 모드일 때 네트워크 연결 복구 (비행기 모드 해제)
   - 수정 전: 사용자가 수동으로 새로고침하기 전까지 오프라인 상태 유지
   - 수정 후: 자동으로 연결 복구 감지 및 Snackbar 알림 표시, 최신 데이터 로딩

3. **캐시 데이터 테스트**:
   - 앱 사용 중 캐시 데이터 생성 (여러 시도 데이터 로드)
   - 네트워크 연결 해제
   - 다른 시도 데이터 요청
   - 수정 전: 새 데이터 로딩 시도 및 무한 로딩
   - 수정 후: 캐시된 데이터가 있으면 표시하고 "오프라인 모드 (캐시 데이터)" 메시지 표시

이 개선으로 사용자는 네트워크 상태 변화에 관계없이 앱을 원활하게 사용할 수 있으며, 오프라인 상태에서도 가능한 한 최선의 경험을 제공받을 수 있습니다.
