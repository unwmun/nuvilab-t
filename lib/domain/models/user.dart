import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// 사용자 정보를 담당하는 모델 클래스
///
/// 사용자 ID, 이름 등 기본 정보를 포함합니다.
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    String? email,
    String? profileImageUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
