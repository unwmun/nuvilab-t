#!/bin/bash

# 모의 API를 사용하는 통합 테스트 실행
echo "모의 API 테스트 실행 중..."
flutter test integration_test/app_mock_test.dart

# 실제 API를 사용하는 통합 테스트 실행 (필요한 경우)
# echo "실제 API 테스트 실행 중..."
# flutter test integration_test/app_test.dart 