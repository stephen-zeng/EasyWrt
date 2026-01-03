// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transient_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CurrentRouter _$CurrentRouterFromJson(Map<String, dynamic> json) {
  return _CurrentRouter.fromJson(json);
}

/// @nodoc
mixin _$CurrentRouter {
  RouterItem get routerItem => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CurrentRouterCopyWith<CurrentRouter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentRouterCopyWith<$Res> {
  factory $CurrentRouterCopyWith(
          CurrentRouter value, $Res Function(CurrentRouter) then) =
      _$CurrentRouterCopyWithImpl<$Res, CurrentRouter>;
  @useResult
  $Res call({RouterItem routerItem, String? token});
}

/// @nodoc
class _$CurrentRouterCopyWithImpl<$Res, $Val extends CurrentRouter>
    implements $CurrentRouterCopyWith<$Res> {
  _$CurrentRouterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routerItem = null,
    Object? token = freezed,
  }) {
    return _then(_value.copyWith(
      routerItem: null == routerItem
          ? _value.routerItem
          : routerItem // ignore: cast_nullable_to_non_nullable
              as RouterItem,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrentRouterImplCopyWith<$Res>
    implements $CurrentRouterCopyWith<$Res> {
  factory _$$CurrentRouterImplCopyWith(
          _$CurrentRouterImpl value, $Res Function(_$CurrentRouterImpl) then) =
      __$$CurrentRouterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RouterItem routerItem, String? token});
}

/// @nodoc
class __$$CurrentRouterImplCopyWithImpl<$Res>
    extends _$CurrentRouterCopyWithImpl<$Res, _$CurrentRouterImpl>
    implements _$$CurrentRouterImplCopyWith<$Res> {
  __$$CurrentRouterImplCopyWithImpl(
      _$CurrentRouterImpl _value, $Res Function(_$CurrentRouterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routerItem = null,
    Object? token = freezed,
  }) {
    return _then(_$CurrentRouterImpl(
      routerItem: null == routerItem
          ? _value.routerItem
          : routerItem // ignore: cast_nullable_to_non_nullable
              as RouterItem,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentRouterImpl implements _CurrentRouter {
  const _$CurrentRouterImpl({required this.routerItem, this.token});

  factory _$CurrentRouterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentRouterImplFromJson(json);

  @override
  final RouterItem routerItem;
  @override
  final String? token;

  @override
  String toString() {
    return 'CurrentRouter(routerItem: $routerItem, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentRouterImpl &&
            (identical(other.routerItem, routerItem) ||
                other.routerItem == routerItem) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, routerItem, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentRouterImplCopyWith<_$CurrentRouterImpl> get copyWith =>
      __$$CurrentRouterImplCopyWithImpl<_$CurrentRouterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentRouterImplToJson(
      this,
    );
  }
}

abstract class _CurrentRouter implements CurrentRouter {
  const factory _CurrentRouter(
      {required final RouterItem routerItem,
      final String? token}) = _$CurrentRouterImpl;

  factory _CurrentRouter.fromJson(Map<String, dynamic> json) =
      _$CurrentRouterImpl.fromJson;

  @override
  RouterItem get routerItem;
  @override
  String? get token;
  @override
  @JsonKey(ignore: true)
  _$$CurrentRouterImplCopyWith<_$CurrentRouterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrentMiddleware _$CurrentMiddlewareFromJson(Map<String, dynamic> json) {
  return _CurrentMiddleware.fromJson(json);
}

/// @nodoc
mixin _$CurrentMiddleware {
  MiddlewareItem get middlewareItem => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CurrentMiddlewareCopyWith<CurrentMiddleware> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentMiddlewareCopyWith<$Res> {
  factory $CurrentMiddlewareCopyWith(
          CurrentMiddleware value, $Res Function(CurrentMiddleware) then) =
      _$CurrentMiddlewareCopyWithImpl<$Res, CurrentMiddleware>;
  @useResult
  $Res call({MiddlewareItem middlewareItem});
}

/// @nodoc
class _$CurrentMiddlewareCopyWithImpl<$Res, $Val extends CurrentMiddleware>
    implements $CurrentMiddlewareCopyWith<$Res> {
  _$CurrentMiddlewareCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? middlewareItem = null,
  }) {
    return _then(_value.copyWith(
      middlewareItem: null == middlewareItem
          ? _value.middlewareItem
          : middlewareItem // ignore: cast_nullable_to_non_nullable
              as MiddlewareItem,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrentMiddlewareImplCopyWith<$Res>
    implements $CurrentMiddlewareCopyWith<$Res> {
  factory _$$CurrentMiddlewareImplCopyWith(_$CurrentMiddlewareImpl value,
          $Res Function(_$CurrentMiddlewareImpl) then) =
      __$$CurrentMiddlewareImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MiddlewareItem middlewareItem});
}

/// @nodoc
class __$$CurrentMiddlewareImplCopyWithImpl<$Res>
    extends _$CurrentMiddlewareCopyWithImpl<$Res, _$CurrentMiddlewareImpl>
    implements _$$CurrentMiddlewareImplCopyWith<$Res> {
  __$$CurrentMiddlewareImplCopyWithImpl(_$CurrentMiddlewareImpl _value,
      $Res Function(_$CurrentMiddlewareImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? middlewareItem = null,
  }) {
    return _then(_$CurrentMiddlewareImpl(
      middlewareItem: null == middlewareItem
          ? _value.middlewareItem
          : middlewareItem // ignore: cast_nullable_to_non_nullable
              as MiddlewareItem,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentMiddlewareImpl implements _CurrentMiddleware {
  const _$CurrentMiddlewareImpl({required this.middlewareItem});

  factory _$CurrentMiddlewareImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentMiddlewareImplFromJson(json);

  @override
  final MiddlewareItem middlewareItem;

  @override
  String toString() {
    return 'CurrentMiddleware(middlewareItem: $middlewareItem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentMiddlewareImpl &&
            (identical(other.middlewareItem, middlewareItem) ||
                other.middlewareItem == middlewareItem));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, middlewareItem);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentMiddlewareImplCopyWith<_$CurrentMiddlewareImpl> get copyWith =>
      __$$CurrentMiddlewareImplCopyWithImpl<_$CurrentMiddlewareImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentMiddlewareImplToJson(
      this,
    );
  }
}

abstract class _CurrentMiddleware implements CurrentMiddleware {
  const factory _CurrentMiddleware(
      {required final MiddlewareItem middlewareItem}) = _$CurrentMiddlewareImpl;

  factory _CurrentMiddleware.fromJson(Map<String, dynamic> json) =
      _$CurrentMiddlewareImpl.fromJson;

  @override
  MiddlewareItem get middlewareItem;
  @override
  @JsonKey(ignore: true)
  _$$CurrentMiddlewareImplCopyWith<_$CurrentMiddlewareImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrentPage _$CurrentPageFromJson(Map<String, dynamic> json) {
  return _CurrentPage.fromJson(json);
}

/// @nodoc
mixin _$CurrentPage {
  String get id => throw _privateConstructorUsedError;
  List<String> get path => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  bool get isEditMode => throw _privateConstructorUsedError;
  List<String>? get widgetChildren => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CurrentPageCopyWith<CurrentPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentPageCopyWith<$Res> {
  factory $CurrentPageCopyWith(
          CurrentPage value, $Res Function(CurrentPage) then) =
      _$CurrentPageCopyWithImpl<$Res, CurrentPage>;
  @useResult
  $Res call(
      {String id,
      List<String> path,
      String name,
      String icon,
      bool isEditMode,
      List<String>? widgetChildren});
}

/// @nodoc
class _$CurrentPageCopyWithImpl<$Res, $Val extends CurrentPage>
    implements $CurrentPageCopyWith<$Res> {
  _$CurrentPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? name = null,
    Object? icon = null,
    Object? isEditMode = null,
    Object? widgetChildren = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      isEditMode: null == isEditMode
          ? _value.isEditMode
          : isEditMode // ignore: cast_nullable_to_non_nullable
              as bool,
      widgetChildren: freezed == widgetChildren
          ? _value.widgetChildren
          : widgetChildren // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrentPageImplCopyWith<$Res>
    implements $CurrentPageCopyWith<$Res> {
  factory _$$CurrentPageImplCopyWith(
          _$CurrentPageImpl value, $Res Function(_$CurrentPageImpl) then) =
      __$$CurrentPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<String> path,
      String name,
      String icon,
      bool isEditMode,
      List<String>? widgetChildren});
}

/// @nodoc
class __$$CurrentPageImplCopyWithImpl<$Res>
    extends _$CurrentPageCopyWithImpl<$Res, _$CurrentPageImpl>
    implements _$$CurrentPageImplCopyWith<$Res> {
  __$$CurrentPageImplCopyWithImpl(
      _$CurrentPageImpl _value, $Res Function(_$CurrentPageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? name = null,
    Object? icon = null,
    Object? isEditMode = null,
    Object? widgetChildren = freezed,
  }) {
    return _then(_$CurrentPageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value._path
          : path // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      isEditMode: null == isEditMode
          ? _value.isEditMode
          : isEditMode // ignore: cast_nullable_to_non_nullable
              as bool,
      widgetChildren: freezed == widgetChildren
          ? _value._widgetChildren
          : widgetChildren // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentPageImpl implements _CurrentPage {
  const _$CurrentPageImpl(
      {required this.id,
      required final List<String> path,
      required this.name,
      required this.icon,
      this.isEditMode = false,
      final List<String>? widgetChildren})
      : _path = path,
        _widgetChildren = widgetChildren;

  factory _$CurrentPageImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentPageImplFromJson(json);

  @override
  final String id;
  final List<String> _path;
  @override
  List<String> get path {
    if (_path is EqualUnmodifiableListView) return _path;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_path);
  }

  @override
  final String name;
  @override
  final String icon;
  @override
  @JsonKey()
  final bool isEditMode;
  final List<String>? _widgetChildren;
  @override
  List<String>? get widgetChildren {
    final value = _widgetChildren;
    if (value == null) return null;
    if (_widgetChildren is EqualUnmodifiableListView) return _widgetChildren;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CurrentPage(id: $id, path: $path, name: $name, icon: $icon, isEditMode: $isEditMode, widgetChildren: $widgetChildren)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentPageImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._path, _path) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isEditMode, isEditMode) ||
                other.isEditMode == isEditMode) &&
            const DeepCollectionEquality()
                .equals(other._widgetChildren, _widgetChildren));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_path),
      name,
      icon,
      isEditMode,
      const DeepCollectionEquality().hash(_widgetChildren));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentPageImplCopyWith<_$CurrentPageImpl> get copyWith =>
      __$$CurrentPageImplCopyWithImpl<_$CurrentPageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentPageImplToJson(
      this,
    );
  }
}

abstract class _CurrentPage implements CurrentPage {
  const factory _CurrentPage(
      {required final String id,
      required final List<String> path,
      required final String name,
      required final String icon,
      final bool isEditMode,
      final List<String>? widgetChildren}) = _$CurrentPageImpl;

  factory _CurrentPage.fromJson(Map<String, dynamic> json) =
      _$CurrentPageImpl.fromJson;

  @override
  String get id;
  @override
  List<String> get path;
  @override
  String get name;
  @override
  String get icon;
  @override
  bool get isEditMode;
  @override
  List<String>? get widgetChildren;
  @override
  @JsonKey(ignore: true)
  _$$CurrentPageImplCopyWith<_$CurrentPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
