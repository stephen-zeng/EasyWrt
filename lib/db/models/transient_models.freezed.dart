// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transient_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CurrentRouter {

 String get id; String get name; String get host; int get port; String get username; String get password; bool get isHttps;
/// Create a copy of CurrentRouter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentRouterCopyWith<CurrentRouter> get copyWith => _$CurrentRouterCopyWithImpl<CurrentRouter>(this as CurrentRouter, _$identity);

  /// Serializes this CurrentRouter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentRouter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.isHttps, isHttps) || other.isHttps == isHttps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,host,port,username,password,isHttps);

@override
String toString() {
  return 'CurrentRouter(id: $id, name: $name, host: $host, port: $port, username: $username, password: $password, isHttps: $isHttps)';
}


}

/// @nodoc
abstract mixin class $CurrentRouterCopyWith<$Res>  {
  factory $CurrentRouterCopyWith(CurrentRouter value, $Res Function(CurrentRouter) _then) = _$CurrentRouterCopyWithImpl;
@useResult
$Res call({
 String id, String name, String host, int port, String username, String password, bool isHttps
});




}
/// @nodoc
class _$CurrentRouterCopyWithImpl<$Res>
    implements $CurrentRouterCopyWith<$Res> {
  _$CurrentRouterCopyWithImpl(this._self, this._then);

  final CurrentRouter _self;
  final $Res Function(CurrentRouter) _then;

/// Create a copy of CurrentRouter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? host = null,Object? port = null,Object? username = null,Object? password = null,Object? isHttps = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,isHttps: null == isHttps ? _self.isHttps : isHttps // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentRouter].
extension CurrentRouterPatterns on CurrentRouter {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentRouter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentRouter() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentRouter value)  $default,){
final _that = this;
switch (_that) {
case _CurrentRouter():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentRouter value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentRouter() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String host,  int port,  String username,  String password,  bool isHttps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentRouter() when $default != null:
return $default(_that.id,_that.name,_that.host,_that.port,_that.username,_that.password,_that.isHttps);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String host,  int port,  String username,  String password,  bool isHttps)  $default,) {final _that = this;
switch (_that) {
case _CurrentRouter():
return $default(_that.id,_that.name,_that.host,_that.port,_that.username,_that.password,_that.isHttps);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String host,  int port,  String username,  String password,  bool isHttps)?  $default,) {final _that = this;
switch (_that) {
case _CurrentRouter() when $default != null:
return $default(_that.id,_that.name,_that.host,_that.port,_that.username,_that.password,_that.isHttps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentRouter implements CurrentRouter {
  const _CurrentRouter({required this.id, required this.name, required this.host, required this.port, required this.username, required this.password, required this.isHttps});
  factory _CurrentRouter.fromJson(Map<String, dynamic> json) => _$CurrentRouterFromJson(json);

@override final  String id;
@override final  String name;
@override final  String host;
@override final  int port;
@override final  String username;
@override final  String password;
@override final  bool isHttps;

/// Create a copy of CurrentRouter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentRouterCopyWith<_CurrentRouter> get copyWith => __$CurrentRouterCopyWithImpl<_CurrentRouter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentRouterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentRouter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.isHttps, isHttps) || other.isHttps == isHttps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,host,port,username,password,isHttps);

@override
String toString() {
  return 'CurrentRouter(id: $id, name: $name, host: $host, port: $port, username: $username, password: $password, isHttps: $isHttps)';
}


}

/// @nodoc
abstract mixin class _$CurrentRouterCopyWith<$Res> implements $CurrentRouterCopyWith<$Res> {
  factory _$CurrentRouterCopyWith(_CurrentRouter value, $Res Function(_CurrentRouter) _then) = __$CurrentRouterCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String host, int port, String username, String password, bool isHttps
});




}
/// @nodoc
class __$CurrentRouterCopyWithImpl<$Res>
    implements _$CurrentRouterCopyWith<$Res> {
  __$CurrentRouterCopyWithImpl(this._self, this._then);

  final _CurrentRouter _self;
  final $Res Function(_CurrentRouter) _then;

/// Create a copy of CurrentRouter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? host = null,Object? port = null,Object? username = null,Object? password = null,Object? isHttps = null,}) {
  return _then(_CurrentRouter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,isHttps: null == isHttps ? _self.isHttps : isHttps // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CurrentMiddleware {

 String get id; List<String> get path; String get name; String get icon; List<String>? get middlewareChildren; List<String>? get pageChildren;
/// Create a copy of CurrentMiddleware
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentMiddlewareCopyWith<CurrentMiddleware> get copyWith => _$CurrentMiddlewareCopyWithImpl<CurrentMiddleware>(this as CurrentMiddleware, _$identity);

  /// Serializes this CurrentMiddleware to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentMiddleware&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.path, path)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.middlewareChildren, middlewareChildren)&&const DeepCollectionEquality().equals(other.pageChildren, pageChildren));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(path),name,icon,const DeepCollectionEquality().hash(middlewareChildren),const DeepCollectionEquality().hash(pageChildren));

@override
String toString() {
  return 'CurrentMiddleware(id: $id, path: $path, name: $name, icon: $icon, middlewareChildren: $middlewareChildren, pageChildren: $pageChildren)';
}


}

/// @nodoc
abstract mixin class $CurrentMiddlewareCopyWith<$Res>  {
  factory $CurrentMiddlewareCopyWith(CurrentMiddleware value, $Res Function(CurrentMiddleware) _then) = _$CurrentMiddlewareCopyWithImpl;
@useResult
$Res call({
 String id, List<String> path, String name, String icon, List<String>? middlewareChildren, List<String>? pageChildren
});




}
/// @nodoc
class _$CurrentMiddlewareCopyWithImpl<$Res>
    implements $CurrentMiddlewareCopyWith<$Res> {
  _$CurrentMiddlewareCopyWithImpl(this._self, this._then);

  final CurrentMiddleware _self;
  final $Res Function(CurrentMiddleware) _then;

/// Create a copy of CurrentMiddleware
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = null,Object? name = null,Object? icon = null,Object? middlewareChildren = freezed,Object? pageChildren = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as List<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,middlewareChildren: freezed == middlewareChildren ? _self.middlewareChildren : middlewareChildren // ignore: cast_nullable_to_non_nullable
as List<String>?,pageChildren: freezed == pageChildren ? _self.pageChildren : pageChildren // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentMiddleware].
extension CurrentMiddlewarePatterns on CurrentMiddleware {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentMiddleware value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentMiddleware() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentMiddleware value)  $default,){
final _that = this;
switch (_that) {
case _CurrentMiddleware():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentMiddleware value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentMiddleware() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<String> path,  String name,  String icon,  List<String>? middlewareChildren,  List<String>? pageChildren)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentMiddleware() when $default != null:
return $default(_that.id,_that.path,_that.name,_that.icon,_that.middlewareChildren,_that.pageChildren);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<String> path,  String name,  String icon,  List<String>? middlewareChildren,  List<String>? pageChildren)  $default,) {final _that = this;
switch (_that) {
case _CurrentMiddleware():
return $default(_that.id,_that.path,_that.name,_that.icon,_that.middlewareChildren,_that.pageChildren);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<String> path,  String name,  String icon,  List<String>? middlewareChildren,  List<String>? pageChildren)?  $default,) {final _that = this;
switch (_that) {
case _CurrentMiddleware() when $default != null:
return $default(_that.id,_that.path,_that.name,_that.icon,_that.middlewareChildren,_that.pageChildren);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentMiddleware implements CurrentMiddleware {
  const _CurrentMiddleware({required this.id, required final  List<String> path, required this.name, required this.icon, final  List<String>? middlewareChildren, final  List<String>? pageChildren}): _path = path,_middlewareChildren = middlewareChildren,_pageChildren = pageChildren;
  factory _CurrentMiddleware.fromJson(Map<String, dynamic> json) => _$CurrentMiddlewareFromJson(json);

@override final  String id;
 final  List<String> _path;
@override List<String> get path {
  if (_path is EqualUnmodifiableListView) return _path;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_path);
}

@override final  String name;
@override final  String icon;
 final  List<String>? _middlewareChildren;
@override List<String>? get middlewareChildren {
  final value = _middlewareChildren;
  if (value == null) return null;
  if (_middlewareChildren is EqualUnmodifiableListView) return _middlewareChildren;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _pageChildren;
@override List<String>? get pageChildren {
  final value = _pageChildren;
  if (value == null) return null;
  if (_pageChildren is EqualUnmodifiableListView) return _pageChildren;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CurrentMiddleware
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentMiddlewareCopyWith<_CurrentMiddleware> get copyWith => __$CurrentMiddlewareCopyWithImpl<_CurrentMiddleware>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentMiddlewareToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentMiddleware&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._path, _path)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other._middlewareChildren, _middlewareChildren)&&const DeepCollectionEquality().equals(other._pageChildren, _pageChildren));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_path),name,icon,const DeepCollectionEquality().hash(_middlewareChildren),const DeepCollectionEquality().hash(_pageChildren));

@override
String toString() {
  return 'CurrentMiddleware(id: $id, path: $path, name: $name, icon: $icon, middlewareChildren: $middlewareChildren, pageChildren: $pageChildren)';
}


}

/// @nodoc
abstract mixin class _$CurrentMiddlewareCopyWith<$Res> implements $CurrentMiddlewareCopyWith<$Res> {
  factory _$CurrentMiddlewareCopyWith(_CurrentMiddleware value, $Res Function(_CurrentMiddleware) _then) = __$CurrentMiddlewareCopyWithImpl;
@override @useResult
$Res call({
 String id, List<String> path, String name, String icon, List<String>? middlewareChildren, List<String>? pageChildren
});




}
/// @nodoc
class __$CurrentMiddlewareCopyWithImpl<$Res>
    implements _$CurrentMiddlewareCopyWith<$Res> {
  __$CurrentMiddlewareCopyWithImpl(this._self, this._then);

  final _CurrentMiddleware _self;
  final $Res Function(_CurrentMiddleware) _then;

/// Create a copy of CurrentMiddleware
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = null,Object? name = null,Object? icon = null,Object? middlewareChildren = freezed,Object? pageChildren = freezed,}) {
  return _then(_CurrentMiddleware(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self._path : path // ignore: cast_nullable_to_non_nullable
as List<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,middlewareChildren: freezed == middlewareChildren ? _self._middlewareChildren : middlewareChildren // ignore: cast_nullable_to_non_nullable
as List<String>?,pageChildren: freezed == pageChildren ? _self._pageChildren : pageChildren // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$CurrentPage {

 String get id; List<String> get path; String get name; String get icon; List<String>? get widgetChildren;
/// Create a copy of CurrentPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentPageCopyWith<CurrentPage> get copyWith => _$CurrentPageCopyWithImpl<CurrentPage>(this as CurrentPage, _$identity);

  /// Serializes this CurrentPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentPage&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.path, path)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.widgetChildren, widgetChildren));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(path),name,icon,const DeepCollectionEquality().hash(widgetChildren));

@override
String toString() {
  return 'CurrentPage(id: $id, path: $path, name: $name, icon: $icon, widgetChildren: $widgetChildren)';
}


}

/// @nodoc
abstract mixin class $CurrentPageCopyWith<$Res>  {
  factory $CurrentPageCopyWith(CurrentPage value, $Res Function(CurrentPage) _then) = _$CurrentPageCopyWithImpl;
@useResult
$Res call({
 String id, List<String> path, String name, String icon, List<String>? widgetChildren
});




}
/// @nodoc
class _$CurrentPageCopyWithImpl<$Res>
    implements $CurrentPageCopyWith<$Res> {
  _$CurrentPageCopyWithImpl(this._self, this._then);

  final CurrentPage _self;
  final $Res Function(CurrentPage) _then;

/// Create a copy of CurrentPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = null,Object? name = null,Object? icon = null,Object? widgetChildren = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as List<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,widgetChildren: freezed == widgetChildren ? _self.widgetChildren : widgetChildren // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentPage].
extension CurrentPagePatterns on CurrentPage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentPage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentPage value)  $default,){
final _that = this;
switch (_that) {
case _CurrentPage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentPage value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentPage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<String> path,  String name,  String icon,  List<String>? widgetChildren)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentPage() when $default != null:
return $default(_that.id,_that.path,_that.name,_that.icon,_that.widgetChildren);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<String> path,  String name,  String icon,  List<String>? widgetChildren)  $default,) {final _that = this;
switch (_that) {
case _CurrentPage():
return $default(_that.id,_that.path,_that.name,_that.icon,_that.widgetChildren);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<String> path,  String name,  String icon,  List<String>? widgetChildren)?  $default,) {final _that = this;
switch (_that) {
case _CurrentPage() when $default != null:
return $default(_that.id,_that.path,_that.name,_that.icon,_that.widgetChildren);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentPage implements CurrentPage {
  const _CurrentPage({required this.id, required final  List<String> path, required this.name, required this.icon, final  List<String>? widgetChildren}): _path = path,_widgetChildren = widgetChildren;
  factory _CurrentPage.fromJson(Map<String, dynamic> json) => _$CurrentPageFromJson(json);

@override final  String id;
 final  List<String> _path;
@override List<String> get path {
  if (_path is EqualUnmodifiableListView) return _path;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_path);
}

@override final  String name;
@override final  String icon;
 final  List<String>? _widgetChildren;
@override List<String>? get widgetChildren {
  final value = _widgetChildren;
  if (value == null) return null;
  if (_widgetChildren is EqualUnmodifiableListView) return _widgetChildren;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CurrentPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentPageCopyWith<_CurrentPage> get copyWith => __$CurrentPageCopyWithImpl<_CurrentPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentPageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentPage&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._path, _path)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other._widgetChildren, _widgetChildren));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_path),name,icon,const DeepCollectionEquality().hash(_widgetChildren));

@override
String toString() {
  return 'CurrentPage(id: $id, path: $path, name: $name, icon: $icon, widgetChildren: $widgetChildren)';
}


}

/// @nodoc
abstract mixin class _$CurrentPageCopyWith<$Res> implements $CurrentPageCopyWith<$Res> {
  factory _$CurrentPageCopyWith(_CurrentPage value, $Res Function(_CurrentPage) _then) = __$CurrentPageCopyWithImpl;
@override @useResult
$Res call({
 String id, List<String> path, String name, String icon, List<String>? widgetChildren
});




}
/// @nodoc
class __$CurrentPageCopyWithImpl<$Res>
    implements _$CurrentPageCopyWith<$Res> {
  __$CurrentPageCopyWithImpl(this._self, this._then);

  final _CurrentPage _self;
  final $Res Function(_CurrentPage) _then;

/// Create a copy of CurrentPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = null,Object? name = null,Object? icon = null,Object? widgetChildren = freezed,}) {
  return _then(_CurrentPage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self._path : path // ignore: cast_nullable_to_non_nullable
as List<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,widgetChildren: freezed == widgetChildren ? _self._widgetChildren : widgetChildren // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
