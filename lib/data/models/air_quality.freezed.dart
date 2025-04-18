// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'air_quality.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AirQualityResponse _$AirQualityResponseFromJson(Map<String, dynamic> json) {
  return _AirQualityResponse.fromJson(json);
}

/// @nodoc
mixin _$AirQualityResponse {
  Response get response => throw _privateConstructorUsedError;

  /// Serializes this AirQualityResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AirQualityResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AirQualityResponseCopyWith<AirQualityResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AirQualityResponseCopyWith<$Res> {
  factory $AirQualityResponseCopyWith(
          AirQualityResponse value, $Res Function(AirQualityResponse) then) =
      _$AirQualityResponseCopyWithImpl<$Res, AirQualityResponse>;
  @useResult
  $Res call({Response response});

  $ResponseCopyWith<$Res> get response;
}

/// @nodoc
class _$AirQualityResponseCopyWithImpl<$Res, $Val extends AirQualityResponse>
    implements $AirQualityResponseCopyWith<$Res> {
  _$AirQualityResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AirQualityResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
  }) {
    return _then(_value.copyWith(
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as Response,
    ) as $Val);
  }

  /// Create a copy of AirQualityResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResponseCopyWith<$Res> get response {
    return $ResponseCopyWith<$Res>(_value.response, (value) {
      return _then(_value.copyWith(response: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AirQualityResponseImplCopyWith<$Res>
    implements $AirQualityResponseCopyWith<$Res> {
  factory _$$AirQualityResponseImplCopyWith(_$AirQualityResponseImpl value,
          $Res Function(_$AirQualityResponseImpl) then) =
      __$$AirQualityResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Response response});

  @override
  $ResponseCopyWith<$Res> get response;
}

/// @nodoc
class __$$AirQualityResponseImplCopyWithImpl<$Res>
    extends _$AirQualityResponseCopyWithImpl<$Res, _$AirQualityResponseImpl>
    implements _$$AirQualityResponseImplCopyWith<$Res> {
  __$$AirQualityResponseImplCopyWithImpl(_$AirQualityResponseImpl _value,
      $Res Function(_$AirQualityResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AirQualityResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
  }) {
    return _then(_$AirQualityResponseImpl(
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as Response,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AirQualityResponseImpl implements _AirQualityResponse {
  const _$AirQualityResponseImpl({required this.response});

  factory _$AirQualityResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AirQualityResponseImplFromJson(json);

  @override
  final Response response;

  @override
  String toString() {
    return 'AirQualityResponse(response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AirQualityResponseImpl &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, response);

  /// Create a copy of AirQualityResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AirQualityResponseImplCopyWith<_$AirQualityResponseImpl> get copyWith =>
      __$$AirQualityResponseImplCopyWithImpl<_$AirQualityResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AirQualityResponseImplToJson(
      this,
    );
  }
}

abstract class _AirQualityResponse implements AirQualityResponse {
  const factory _AirQualityResponse({required final Response response}) =
      _$AirQualityResponseImpl;

  factory _AirQualityResponse.fromJson(Map<String, dynamic> json) =
      _$AirQualityResponseImpl.fromJson;

  @override
  Response get response;

  /// Create a copy of AirQualityResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AirQualityResponseImplCopyWith<_$AirQualityResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Response _$ResponseFromJson(Map<String, dynamic> json) {
  return _Response.fromJson(json);
}

/// @nodoc
mixin _$Response {
  Body get body => throw _privateConstructorUsedError;

  /// Serializes this Response to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResponseCopyWith<Response> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseCopyWith<$Res> {
  factory $ResponseCopyWith(Response value, $Res Function(Response) then) =
      _$ResponseCopyWithImpl<$Res, Response>;
  @useResult
  $Res call({Body body});

  $BodyCopyWith<$Res> get body;
}

/// @nodoc
class _$ResponseCopyWithImpl<$Res, $Val extends Response>
    implements $ResponseCopyWith<$Res> {
  _$ResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? body = null,
  }) {
    return _then(_value.copyWith(
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as Body,
    ) as $Val);
  }

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BodyCopyWith<$Res> get body {
    return $BodyCopyWith<$Res>(_value.body, (value) {
      return _then(_value.copyWith(body: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResponseImplCopyWith<$Res>
    implements $ResponseCopyWith<$Res> {
  factory _$$ResponseImplCopyWith(
          _$ResponseImpl value, $Res Function(_$ResponseImpl) then) =
      __$$ResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Body body});

  @override
  $BodyCopyWith<$Res> get body;
}

/// @nodoc
class __$$ResponseImplCopyWithImpl<$Res>
    extends _$ResponseCopyWithImpl<$Res, _$ResponseImpl>
    implements _$$ResponseImplCopyWith<$Res> {
  __$$ResponseImplCopyWithImpl(
      _$ResponseImpl _value, $Res Function(_$ResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? body = null,
  }) {
    return _then(_$ResponseImpl(
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as Body,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResponseImpl implements _Response {
  const _$ResponseImpl({required this.body});

  factory _$ResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResponseImplFromJson(json);

  @override
  final Body body;

  @override
  String toString() {
    return 'Response(body: $body)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseImpl &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, body);

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseImplCopyWith<_$ResponseImpl> get copyWith =>
      __$$ResponseImplCopyWithImpl<_$ResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResponseImplToJson(
      this,
    );
  }
}

abstract class _Response implements Response {
  const factory _Response({required final Body body}) = _$ResponseImpl;

  factory _Response.fromJson(Map<String, dynamic> json) =
      _$ResponseImpl.fromJson;

  @override
  Body get body;

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResponseImplCopyWith<_$ResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Body _$BodyFromJson(Map<String, dynamic> json) {
  return _Body.fromJson(json);
}

/// @nodoc
mixin _$Body {
  int get totalCount => throw _privateConstructorUsedError;
  List<AirQualityItem> get items => throw _privateConstructorUsedError;

  /// Serializes this Body to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyCopyWith<Body> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyCopyWith<$Res> {
  factory $BodyCopyWith(Body value, $Res Function(Body) then) =
      _$BodyCopyWithImpl<$Res, Body>;
  @useResult
  $Res call({int totalCount, List<AirQualityItem> items});
}

/// @nodoc
class _$BodyCopyWithImpl<$Res, $Val extends Body>
    implements $BodyCopyWith<$Res> {
  _$BodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<AirQualityItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodyImplCopyWith<$Res> implements $BodyCopyWith<$Res> {
  factory _$$BodyImplCopyWith(
          _$BodyImpl value, $Res Function(_$BodyImpl) then) =
      __$$BodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalCount, List<AirQualityItem> items});
}

/// @nodoc
class __$$BodyImplCopyWithImpl<$Res>
    extends _$BodyCopyWithImpl<$Res, _$BodyImpl>
    implements _$$BodyImplCopyWith<$Res> {
  __$$BodyImplCopyWithImpl(_$BodyImpl _value, $Res Function(_$BodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? items = null,
  }) {
    return _then(_$BodyImpl(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<AirQualityItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyImpl implements _Body {
  const _$BodyImpl(
      {required this.totalCount, required final List<AirQualityItem> items})
      : _items = items;

  factory _$BodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyImplFromJson(json);

  @override
  final int totalCount;
  final List<AirQualityItem> _items;
  @override
  List<AirQualityItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'Body(totalCount: $totalCount, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, totalCount, const DeepCollectionEquality().hash(_items));

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyImplCopyWith<_$BodyImpl> get copyWith =>
      __$$BodyImplCopyWithImpl<_$BodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyImplToJson(
      this,
    );
  }
}

abstract class _Body implements Body {
  const factory _Body(
      {required final int totalCount,
      required final List<AirQualityItem> items}) = _$BodyImpl;

  factory _Body.fromJson(Map<String, dynamic> json) = _$BodyImpl.fromJson;

  @override
  int get totalCount;
  @override
  List<AirQualityItem> get items;

  /// Create a copy of Body
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyImplCopyWith<_$BodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AirQualityItem _$AirQualityItemFromJson(Map<String, dynamic> json) {
  return _AirQualityItem.fromJson(json);
}

/// @nodoc
mixin _$AirQualityItem {
  String get stationName => throw _privateConstructorUsedError;
  String get sidoName => throw _privateConstructorUsedError;
  String get dataTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get so2Value => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get coValue => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get o3Value => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String? get no2Value => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get pm10Value => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get pm25Value => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get khaiValue => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get so2Grade => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get coGrade => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get o3Grade => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String? get no2Grade => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get pm10Grade => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get pm25Grade => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String? get khaiGrade => throw _privateConstructorUsedError;
  String? get so2Flag => throw _privateConstructorUsedError;
  String? get coFlag => throw _privateConstructorUsedError;
  String? get o3Flag => throw _privateConstructorUsedError;
  String? get no2Flag => throw _privateConstructorUsedError;
  String? get pm10Flag => throw _privateConstructorUsedError;
  String? get pm25Flag => throw _privateConstructorUsedError;

  /// Serializes this AirQualityItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AirQualityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AirQualityItemCopyWith<AirQualityItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AirQualityItemCopyWith<$Res> {
  factory $AirQualityItemCopyWith(
          AirQualityItem value, $Res Function(AirQualityItem) then) =
      _$AirQualityItemCopyWithImpl<$Res, AirQualityItem>;
  @useResult
  $Res call(
      {String stationName,
      String sidoName,
      String dataTime,
      @JsonKey(fromJson: _stringFromJson) String so2Value,
      @JsonKey(fromJson: _stringFromJson) String coValue,
      @JsonKey(fromJson: _stringFromJson) String o3Value,
      @JsonKey(fromJson: _stringFromJson) String? no2Value,
      @JsonKey(fromJson: _stringFromJson) String pm10Value,
      @JsonKey(fromJson: _stringFromJson) String pm25Value,
      @JsonKey(fromJson: _stringFromJson) String khaiValue,
      @JsonKey(fromJson: _stringFromJson) String so2Grade,
      @JsonKey(fromJson: _stringFromJson) String coGrade,
      @JsonKey(fromJson: _stringFromJson) String o3Grade,
      @JsonKey(fromJson: _stringFromJson) String? no2Grade,
      @JsonKey(fromJson: _stringFromJson) String pm10Grade,
      @JsonKey(fromJson: _stringFromJson) String pm25Grade,
      @JsonKey(fromJson: _stringFromJson) String? khaiGrade,
      String? so2Flag,
      String? coFlag,
      String? o3Flag,
      String? no2Flag,
      String? pm10Flag,
      String? pm25Flag});
}

/// @nodoc
class _$AirQualityItemCopyWithImpl<$Res, $Val extends AirQualityItem>
    implements $AirQualityItemCopyWith<$Res> {
  _$AirQualityItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AirQualityItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stationName = null,
    Object? sidoName = null,
    Object? dataTime = null,
    Object? so2Value = null,
    Object? coValue = null,
    Object? o3Value = null,
    Object? no2Value = freezed,
    Object? pm10Value = null,
    Object? pm25Value = null,
    Object? khaiValue = null,
    Object? so2Grade = null,
    Object? coGrade = null,
    Object? o3Grade = null,
    Object? no2Grade = freezed,
    Object? pm10Grade = null,
    Object? pm25Grade = null,
    Object? khaiGrade = freezed,
    Object? so2Flag = freezed,
    Object? coFlag = freezed,
    Object? o3Flag = freezed,
    Object? no2Flag = freezed,
    Object? pm10Flag = freezed,
    Object? pm25Flag = freezed,
  }) {
    return _then(_value.copyWith(
      stationName: null == stationName
          ? _value.stationName
          : stationName // ignore: cast_nullable_to_non_nullable
              as String,
      sidoName: null == sidoName
          ? _value.sidoName
          : sidoName // ignore: cast_nullable_to_non_nullable
              as String,
      dataTime: null == dataTime
          ? _value.dataTime
          : dataTime // ignore: cast_nullable_to_non_nullable
              as String,
      so2Value: null == so2Value
          ? _value.so2Value
          : so2Value // ignore: cast_nullable_to_non_nullable
              as String,
      coValue: null == coValue
          ? _value.coValue
          : coValue // ignore: cast_nullable_to_non_nullable
              as String,
      o3Value: null == o3Value
          ? _value.o3Value
          : o3Value // ignore: cast_nullable_to_non_nullable
              as String,
      no2Value: freezed == no2Value
          ? _value.no2Value
          : no2Value // ignore: cast_nullable_to_non_nullable
              as String?,
      pm10Value: null == pm10Value
          ? _value.pm10Value
          : pm10Value // ignore: cast_nullable_to_non_nullable
              as String,
      pm25Value: null == pm25Value
          ? _value.pm25Value
          : pm25Value // ignore: cast_nullable_to_non_nullable
              as String,
      khaiValue: null == khaiValue
          ? _value.khaiValue
          : khaiValue // ignore: cast_nullable_to_non_nullable
              as String,
      so2Grade: null == so2Grade
          ? _value.so2Grade
          : so2Grade // ignore: cast_nullable_to_non_nullable
              as String,
      coGrade: null == coGrade
          ? _value.coGrade
          : coGrade // ignore: cast_nullable_to_non_nullable
              as String,
      o3Grade: null == o3Grade
          ? _value.o3Grade
          : o3Grade // ignore: cast_nullable_to_non_nullable
              as String,
      no2Grade: freezed == no2Grade
          ? _value.no2Grade
          : no2Grade // ignore: cast_nullable_to_non_nullable
              as String?,
      pm10Grade: null == pm10Grade
          ? _value.pm10Grade
          : pm10Grade // ignore: cast_nullable_to_non_nullable
              as String,
      pm25Grade: null == pm25Grade
          ? _value.pm25Grade
          : pm25Grade // ignore: cast_nullable_to_non_nullable
              as String,
      khaiGrade: freezed == khaiGrade
          ? _value.khaiGrade
          : khaiGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      so2Flag: freezed == so2Flag
          ? _value.so2Flag
          : so2Flag // ignore: cast_nullable_to_non_nullable
              as String?,
      coFlag: freezed == coFlag
          ? _value.coFlag
          : coFlag // ignore: cast_nullable_to_non_nullable
              as String?,
      o3Flag: freezed == o3Flag
          ? _value.o3Flag
          : o3Flag // ignore: cast_nullable_to_non_nullable
              as String?,
      no2Flag: freezed == no2Flag
          ? _value.no2Flag
          : no2Flag // ignore: cast_nullable_to_non_nullable
              as String?,
      pm10Flag: freezed == pm10Flag
          ? _value.pm10Flag
          : pm10Flag // ignore: cast_nullable_to_non_nullable
              as String?,
      pm25Flag: freezed == pm25Flag
          ? _value.pm25Flag
          : pm25Flag // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AirQualityItemImplCopyWith<$Res>
    implements $AirQualityItemCopyWith<$Res> {
  factory _$$AirQualityItemImplCopyWith(_$AirQualityItemImpl value,
          $Res Function(_$AirQualityItemImpl) then) =
      __$$AirQualityItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String stationName,
      String sidoName,
      String dataTime,
      @JsonKey(fromJson: _stringFromJson) String so2Value,
      @JsonKey(fromJson: _stringFromJson) String coValue,
      @JsonKey(fromJson: _stringFromJson) String o3Value,
      @JsonKey(fromJson: _stringFromJson) String? no2Value,
      @JsonKey(fromJson: _stringFromJson) String pm10Value,
      @JsonKey(fromJson: _stringFromJson) String pm25Value,
      @JsonKey(fromJson: _stringFromJson) String khaiValue,
      @JsonKey(fromJson: _stringFromJson) String so2Grade,
      @JsonKey(fromJson: _stringFromJson) String coGrade,
      @JsonKey(fromJson: _stringFromJson) String o3Grade,
      @JsonKey(fromJson: _stringFromJson) String? no2Grade,
      @JsonKey(fromJson: _stringFromJson) String pm10Grade,
      @JsonKey(fromJson: _stringFromJson) String pm25Grade,
      @JsonKey(fromJson: _stringFromJson) String? khaiGrade,
      String? so2Flag,
      String? coFlag,
      String? o3Flag,
      String? no2Flag,
      String? pm10Flag,
      String? pm25Flag});
}

/// @nodoc
class __$$AirQualityItemImplCopyWithImpl<$Res>
    extends _$AirQualityItemCopyWithImpl<$Res, _$AirQualityItemImpl>
    implements _$$AirQualityItemImplCopyWith<$Res> {
  __$$AirQualityItemImplCopyWithImpl(
      _$AirQualityItemImpl _value, $Res Function(_$AirQualityItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of AirQualityItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stationName = null,
    Object? sidoName = null,
    Object? dataTime = null,
    Object? so2Value = null,
    Object? coValue = null,
    Object? o3Value = null,
    Object? no2Value = freezed,
    Object? pm10Value = null,
    Object? pm25Value = null,
    Object? khaiValue = null,
    Object? so2Grade = null,
    Object? coGrade = null,
    Object? o3Grade = null,
    Object? no2Grade = freezed,
    Object? pm10Grade = null,
    Object? pm25Grade = null,
    Object? khaiGrade = freezed,
    Object? so2Flag = freezed,
    Object? coFlag = freezed,
    Object? o3Flag = freezed,
    Object? no2Flag = freezed,
    Object? pm10Flag = freezed,
    Object? pm25Flag = freezed,
  }) {
    return _then(_$AirQualityItemImpl(
      stationName: null == stationName
          ? _value.stationName
          : stationName // ignore: cast_nullable_to_non_nullable
              as String,
      sidoName: null == sidoName
          ? _value.sidoName
          : sidoName // ignore: cast_nullable_to_non_nullable
              as String,
      dataTime: null == dataTime
          ? _value.dataTime
          : dataTime // ignore: cast_nullable_to_non_nullable
              as String,
      so2Value: null == so2Value
          ? _value.so2Value
          : so2Value // ignore: cast_nullable_to_non_nullable
              as String,
      coValue: null == coValue
          ? _value.coValue
          : coValue // ignore: cast_nullable_to_non_nullable
              as String,
      o3Value: null == o3Value
          ? _value.o3Value
          : o3Value // ignore: cast_nullable_to_non_nullable
              as String,
      no2Value: freezed == no2Value
          ? _value.no2Value
          : no2Value // ignore: cast_nullable_to_non_nullable
              as String?,
      pm10Value: null == pm10Value
          ? _value.pm10Value
          : pm10Value // ignore: cast_nullable_to_non_nullable
              as String,
      pm25Value: null == pm25Value
          ? _value.pm25Value
          : pm25Value // ignore: cast_nullable_to_non_nullable
              as String,
      khaiValue: null == khaiValue
          ? _value.khaiValue
          : khaiValue // ignore: cast_nullable_to_non_nullable
              as String,
      so2Grade: null == so2Grade
          ? _value.so2Grade
          : so2Grade // ignore: cast_nullable_to_non_nullable
              as String,
      coGrade: null == coGrade
          ? _value.coGrade
          : coGrade // ignore: cast_nullable_to_non_nullable
              as String,
      o3Grade: null == o3Grade
          ? _value.o3Grade
          : o3Grade // ignore: cast_nullable_to_non_nullable
              as String,
      no2Grade: freezed == no2Grade
          ? _value.no2Grade
          : no2Grade // ignore: cast_nullable_to_non_nullable
              as String?,
      pm10Grade: null == pm10Grade
          ? _value.pm10Grade
          : pm10Grade // ignore: cast_nullable_to_non_nullable
              as String,
      pm25Grade: null == pm25Grade
          ? _value.pm25Grade
          : pm25Grade // ignore: cast_nullable_to_non_nullable
              as String,
      khaiGrade: freezed == khaiGrade
          ? _value.khaiGrade
          : khaiGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      so2Flag: freezed == so2Flag
          ? _value.so2Flag
          : so2Flag // ignore: cast_nullable_to_non_nullable
              as String?,
      coFlag: freezed == coFlag
          ? _value.coFlag
          : coFlag // ignore: cast_nullable_to_non_nullable
              as String?,
      o3Flag: freezed == o3Flag
          ? _value.o3Flag
          : o3Flag // ignore: cast_nullable_to_non_nullable
              as String?,
      no2Flag: freezed == no2Flag
          ? _value.no2Flag
          : no2Flag // ignore: cast_nullable_to_non_nullable
              as String?,
      pm10Flag: freezed == pm10Flag
          ? _value.pm10Flag
          : pm10Flag // ignore: cast_nullable_to_non_nullable
              as String?,
      pm25Flag: freezed == pm25Flag
          ? _value.pm25Flag
          : pm25Flag // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AirQualityItemImpl implements _AirQualityItem {
  const _$AirQualityItemImpl(
      {required this.stationName,
      required this.sidoName,
      required this.dataTime,
      @JsonKey(fromJson: _stringFromJson) required this.so2Value,
      @JsonKey(fromJson: _stringFromJson) required this.coValue,
      @JsonKey(fromJson: _stringFromJson) required this.o3Value,
      @JsonKey(fromJson: _stringFromJson) this.no2Value,
      @JsonKey(fromJson: _stringFromJson) required this.pm10Value,
      @JsonKey(fromJson: _stringFromJson) required this.pm25Value,
      @JsonKey(fromJson: _stringFromJson) required this.khaiValue,
      @JsonKey(fromJson: _stringFromJson) required this.so2Grade,
      @JsonKey(fromJson: _stringFromJson) required this.coGrade,
      @JsonKey(fromJson: _stringFromJson) required this.o3Grade,
      @JsonKey(fromJson: _stringFromJson) this.no2Grade,
      @JsonKey(fromJson: _stringFromJson) required this.pm10Grade,
      @JsonKey(fromJson: _stringFromJson) required this.pm25Grade,
      @JsonKey(fromJson: _stringFromJson) this.khaiGrade,
      this.so2Flag,
      this.coFlag,
      this.o3Flag,
      this.no2Flag,
      this.pm10Flag,
      this.pm25Flag});

  factory _$AirQualityItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AirQualityItemImplFromJson(json);

  @override
  final String stationName;
  @override
  final String sidoName;
  @override
  final String dataTime;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String so2Value;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String coValue;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String o3Value;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String? no2Value;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String pm10Value;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String pm25Value;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String khaiValue;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String so2Grade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String coGrade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String o3Grade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String? no2Grade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String pm10Grade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String pm25Grade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String? khaiGrade;
  @override
  final String? so2Flag;
  @override
  final String? coFlag;
  @override
  final String? o3Flag;
  @override
  final String? no2Flag;
  @override
  final String? pm10Flag;
  @override
  final String? pm25Flag;

  @override
  String toString() {
    return 'AirQualityItem(stationName: $stationName, sidoName: $sidoName, dataTime: $dataTime, so2Value: $so2Value, coValue: $coValue, o3Value: $o3Value, no2Value: $no2Value, pm10Value: $pm10Value, pm25Value: $pm25Value, khaiValue: $khaiValue, so2Grade: $so2Grade, coGrade: $coGrade, o3Grade: $o3Grade, no2Grade: $no2Grade, pm10Grade: $pm10Grade, pm25Grade: $pm25Grade, khaiGrade: $khaiGrade, so2Flag: $so2Flag, coFlag: $coFlag, o3Flag: $o3Flag, no2Flag: $no2Flag, pm10Flag: $pm10Flag, pm25Flag: $pm25Flag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AirQualityItemImpl &&
            (identical(other.stationName, stationName) ||
                other.stationName == stationName) &&
            (identical(other.sidoName, sidoName) ||
                other.sidoName == sidoName) &&
            (identical(other.dataTime, dataTime) ||
                other.dataTime == dataTime) &&
            (identical(other.so2Value, so2Value) ||
                other.so2Value == so2Value) &&
            (identical(other.coValue, coValue) || other.coValue == coValue) &&
            (identical(other.o3Value, o3Value) || other.o3Value == o3Value) &&
            (identical(other.no2Value, no2Value) ||
                other.no2Value == no2Value) &&
            (identical(other.pm10Value, pm10Value) ||
                other.pm10Value == pm10Value) &&
            (identical(other.pm25Value, pm25Value) ||
                other.pm25Value == pm25Value) &&
            (identical(other.khaiValue, khaiValue) ||
                other.khaiValue == khaiValue) &&
            (identical(other.so2Grade, so2Grade) ||
                other.so2Grade == so2Grade) &&
            (identical(other.coGrade, coGrade) || other.coGrade == coGrade) &&
            (identical(other.o3Grade, o3Grade) || other.o3Grade == o3Grade) &&
            (identical(other.no2Grade, no2Grade) ||
                other.no2Grade == no2Grade) &&
            (identical(other.pm10Grade, pm10Grade) ||
                other.pm10Grade == pm10Grade) &&
            (identical(other.pm25Grade, pm25Grade) ||
                other.pm25Grade == pm25Grade) &&
            (identical(other.khaiGrade, khaiGrade) ||
                other.khaiGrade == khaiGrade) &&
            (identical(other.so2Flag, so2Flag) || other.so2Flag == so2Flag) &&
            (identical(other.coFlag, coFlag) || other.coFlag == coFlag) &&
            (identical(other.o3Flag, o3Flag) || other.o3Flag == o3Flag) &&
            (identical(other.no2Flag, no2Flag) || other.no2Flag == no2Flag) &&
            (identical(other.pm10Flag, pm10Flag) ||
                other.pm10Flag == pm10Flag) &&
            (identical(other.pm25Flag, pm25Flag) ||
                other.pm25Flag == pm25Flag));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        stationName,
        sidoName,
        dataTime,
        so2Value,
        coValue,
        o3Value,
        no2Value,
        pm10Value,
        pm25Value,
        khaiValue,
        so2Grade,
        coGrade,
        o3Grade,
        no2Grade,
        pm10Grade,
        pm25Grade,
        khaiGrade,
        so2Flag,
        coFlag,
        o3Flag,
        no2Flag,
        pm10Flag,
        pm25Flag
      ]);

  /// Create a copy of AirQualityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AirQualityItemImplCopyWith<_$AirQualityItemImpl> get copyWith =>
      __$$AirQualityItemImplCopyWithImpl<_$AirQualityItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AirQualityItemImplToJson(
      this,
    );
  }
}

abstract class _AirQualityItem implements AirQualityItem {
  const factory _AirQualityItem(
      {required final String stationName,
      required final String sidoName,
      required final String dataTime,
      @JsonKey(fromJson: _stringFromJson) required final String so2Value,
      @JsonKey(fromJson: _stringFromJson) required final String coValue,
      @JsonKey(fromJson: _stringFromJson) required final String o3Value,
      @JsonKey(fromJson: _stringFromJson) final String? no2Value,
      @JsonKey(fromJson: _stringFromJson) required final String pm10Value,
      @JsonKey(fromJson: _stringFromJson) required final String pm25Value,
      @JsonKey(fromJson: _stringFromJson) required final String khaiValue,
      @JsonKey(fromJson: _stringFromJson) required final String so2Grade,
      @JsonKey(fromJson: _stringFromJson) required final String coGrade,
      @JsonKey(fromJson: _stringFromJson) required final String o3Grade,
      @JsonKey(fromJson: _stringFromJson) final String? no2Grade,
      @JsonKey(fromJson: _stringFromJson) required final String pm10Grade,
      @JsonKey(fromJson: _stringFromJson) required final String pm25Grade,
      @JsonKey(fromJson: _stringFromJson) final String? khaiGrade,
      final String? so2Flag,
      final String? coFlag,
      final String? o3Flag,
      final String? no2Flag,
      final String? pm10Flag,
      final String? pm25Flag}) = _$AirQualityItemImpl;

  factory _AirQualityItem.fromJson(Map<String, dynamic> json) =
      _$AirQualityItemImpl.fromJson;

  @override
  String get stationName;
  @override
  String get sidoName;
  @override
  String get dataTime;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get so2Value;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get coValue;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get o3Value;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String? get no2Value;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get pm10Value;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get pm25Value;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get khaiValue;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get so2Grade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get coGrade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get o3Grade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String? get no2Grade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get pm10Grade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get pm25Grade;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String? get khaiGrade;
  @override
  String? get so2Flag;
  @override
  String? get coFlag;
  @override
  String? get o3Flag;
  @override
  String? get no2Flag;
  @override
  String? get pm10Flag;
  @override
  String? get pm25Flag;

  /// Create a copy of AirQualityItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AirQualityItemImplCopyWith<_$AirQualityItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
