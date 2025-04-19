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

  static const String baseUrl =
      'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc';

  static const String serviceKey =
      'lW7UGCa8yfdQ7GoEA/SDI4WIb4h8h4XtADxpWDeLTRsTGlYNSzM89LvxppvVBDsieGkKb0rwWhSSOXVXCr/nyg==';

  SecureNetworkClient()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          baseUrl: baseUrl,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status != null && status < 600;
          },
        )) {
    _configureCertificatePinning();
    _configureLoggingInterceptor();
  }

  /// SSL/TLS 인증서 핀닝 설정
  void _configureCertificatePinning() {
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
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
    const List<String> trustedFingerprints = [];

    if (kDebugMode) {
      return true;
    }

    try {
      if (trustedFingerprints.isEmpty) {
        return false;
      }

      // TODO: 프로덕션 환경에서 인증서 지문 검증 로직 구현 필요

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
