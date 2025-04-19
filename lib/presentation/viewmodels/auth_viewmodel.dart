import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/core/di/dependency_injection.dart';
import 'package:nubilab/core/security/secure_storage.dart';
import 'package:nubilab/domain/models/user.dart';
import 'package:injectable/injectable.dart';

/// 인증 상태를 관리하는 뷰모델 클래스
///
/// 사용자 로그인, 로그아웃 및 인증 토큰 관리를 담당합니다.
@injectable
class AuthViewModel extends StateNotifier<AsyncValue<User?>> {
  final SecureStorage _secureStorage;

  // 보안 스토리지 키
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  AuthViewModel(this._secureStorage) : super(const AsyncValue.loading()) {
    // 앱 시작 시 저장된 토큰 확인
    _loadSavedToken();
  }

  /// 저장된 인증 토큰을 로드하고 상태를 갱신합니다.
  Future<void> _loadSavedToken() async {
    try {
      final token = await _secureStorage.getSecureData(_tokenKey);
      final userId = await _secureStorage.getSecureData(_userIdKey);

      if (token != null && userId != null) {
        // 토큰이 존재하면 사용자 정보 로드 (예시)
        state = AsyncValue.data(User(id: userId, name: '사용자'));
      } else {
        // 저장된 토큰이 없으면 로그아웃 상태
        state = const AsyncValue.data(null);
      }
    } catch (e) {
      // 오류 발생 시 로그아웃 상태로 설정
      state = AsyncValue.error(e, StackTrace.current);
      await logout(); // 오류 발생 시 로그아웃 처리
    }
  }

  /// 사용자 로그인을 처리합니다.
  Future<void> login(String username, String password) async {
    try {
      state = const AsyncValue.loading();

      // 실제 API 로그인 로직 구현 위치 (예시)
      // final response = await _authRepository.login(username, password);

      // 예시 토큰 (실제로는 API 응답에서 받아온 토큰 사용)
      const token = 'example_secure_token';
      const refreshToken = 'example_refresh_token';
      const userId = 'user_123';

      // 토큰을 보안 스토리지에 안전하게 저장
      await _secureStorage.saveSecureData(_tokenKey, token);
      await _secureStorage.saveSecureData(_refreshTokenKey, refreshToken);
      await _secureStorage.saveSecureData(_userIdKey, userId);

      // 로그인 성공 상태로 설정
      state = AsyncValue.data(User(id: userId, name: username));
    } catch (e) {
      // 로그인 실패 상태로 설정
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 사용자 로그아웃을 처리합니다.
  Future<void> logout() async {
    try {
      // 모든 보안 데이터 삭제
      await _secureStorage.deleteSecureData(_tokenKey);
      await _secureStorage.deleteSecureData(_refreshTokenKey);
      await _secureStorage.deleteSecureData(_userIdKey);

      // 로그아웃 상태로 설정
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 저장된 토큰을 안전하게 조회합니다.
  Future<String?> getToken() async {
    return await _secureStorage.getSecureData(_tokenKey);
  }
}

// 인증 상태 관리를 위한 Provider 정의
final authViewModelProvider = Provider<AuthViewModel>((ref) {
  return AuthViewModel(getIt<SecureStorage>());
});

final authStateProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<User?>>((ref) {
  return ref.watch(authViewModelProvider);
});
