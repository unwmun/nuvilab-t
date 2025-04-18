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

## 사용된 공공 API

- 대기오염정보 조회 서비스 (한국환경공단)
- 엔드포인트: `http://apis.data.go.kr/B552584/ArpltnInforInqireSvc`

## 라이센스

이 프로젝트는 MIT 라이센스로 배포됩니다.
