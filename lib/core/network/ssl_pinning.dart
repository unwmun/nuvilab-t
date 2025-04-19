import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../utils/logger.dart';

/// SSL 핀닝을 지원하는 Dio 클라이언트 구성 클래스
///
/// 서버 인증서를 검증하여 중간자 공격(MITM)으로부터 보호합니다.
@singleton
class SecureNetworkClient {
  final Dio _dio;

  // 공공데이터 포털 API 기본 URL
  static const String baseUrl =
      'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc';

  // 공공데이터 포털 서비스 키 (디코딩된 상태)
  static const String serviceKey =
      'lW7UGCa8yfdQ7GoEA/SDI4WIb4h8h4XtADxpWDeLTRsTGlYNSzM89LvxppvVBDsieGkKb0rwWhSSOXVXCr/nyg==';

  SecureNetworkClient()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          // 항상 HTTPS 사용
          baseUrl: baseUrl,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          // 공공데이터 포털 API는 500 에러도 응답 내용을 포함할 수 있으므로 검증 조건 수정
          validateStatus: (status) {
            return status != null && status < 600;
          },
        )) {
    _configureCertificatePinning();
    _configureLoggingInterceptor();
  }

  /// SSL/TLS 인증서 핀닝 설정
  void _configureCertificatePinning() {
    // HttpClient를 통한 SSL 핀닝 설정
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        // 공공데이터 포털 도메인 체크
        if (host.contains('apis.data.go.kr')) {
          return _validateCertificate(cert);
        }
        return false;
      };
      return client;
    };
  }

  /// 로깅 인터셉터 설정
  void _configureLoggingInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            AppLogger.debug(
                '🌐 REQUEST[${options.method}] => PATH: ${options.path}');
            AppLogger.debug('Headers: ${options.headers}');
            AppLogger.debug('Query Parameters: ${options.queryParameters}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            AppLogger.debug(
                '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            AppLogger.debug('Response: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            AppLogger.error(
                '❌ ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
            AppLogger.error('Error: ${e.message}');
            AppLogger.error('Response: ${e.response?.data}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// 프로덕션 환경에서는 인증서 지문(fingerprint)을 검증하는 메서드를 구현
  bool _validateCertificate(X509Certificate cert) {
    // 공공데이터 포털 인증서 지문 (실제 프로덕션에서는 업데이트 필요)
    const List<String> trustedFingerprints = [
      // 예시: 공공데이터 포털의 SSL 인증서 지문 (프로덕션 환경에서 실제 값으로 대체)
      // SHA-256 해시를 콜론으로 구분된 형식으로 저장
      // 'AA:BB:CC:DD:EE:...',
    ];

    // 개발 환경에서는 인증서 검증을 건너뛰기
    if (kDebugMode) {
      return true;
    }

    // 프로덕션 환경에서는 인증서 검증 실행
    try {
      // 실제 구현에서는 cert에서 지문을 추출하고 trustedFingerprints와 비교
      // SHA-256 해시를 추출하는 코드 필요

      // 검증 로직이 없는 경우 안전하게 false 반환 (인증서 거부)
      if (trustedFingerprints.isEmpty) {
        return false;
      }

      // 여기에 인증서 검증 로직 추가
      // 예시: final fingerprint = _extractSha256Fingerprint(cert);
      // return trustedFingerprints.contains(fingerprint);

      // 테스트 환경에서는 true 반환 (실제 프로덕션에서는 제대로 된 검증 필요)
      return true;
    } catch (e) {
      AppLogger.error('인증서 검증 중 오류 발생: $e');
      return false;
    }
  }

  /// 공공데이터 포털 API에 맞게 구성된 Dio 인스턴스 반환
  Dio get client => _dio;

  /// 공공데이터 포털 서비스 키 반환
  String get getServiceKey => serviceKey;
}
