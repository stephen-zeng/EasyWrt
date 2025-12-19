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

 RouterItem get routerItem; String? get token;
/// Create a copy of CurrentRouter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentRouterCopyWith<CurrentRouter> get copyWith => _$CurrentRouterCopyWithImpl<CurrentRouter>(this as CurrentRouter, _$identity);

  /// Serializes this CurrentRouter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentRouter&&(identical(other.routerItem, routerItem) || other.routerItem == routerItem)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,routerItem,token);

@override
String toString() {
  return 'CurrentRouter(routerItem: $routerItem, token: $token)';
}


}

/// @nodoc
abstract mixin class $CurrentRouterCopyWith<$Res>  {
  factory $CurrentRouterCopyWith(CurrentRouter value, $Res Function(CurrentRouter) _then) = _$CurrentRouterCopyWithImpl;
@useResult
$Res call({
 RouterItem routerItem, String? token
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
@pragma('vm:prefer-inline') @override $Res call({Object? routerItem = null,Object? token = freezed,}) {
  return _then(_self.copyWith(
routerItem: null == routerItem ? _self.routerItem : routerItem // ignore: cast_nullable_to_non_nullable
as RouterItem,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RouterItem routerItem,  String? token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentRouter() when $default != null:
return $default(_that.routerItem,_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RouterItem routerItem,  String? token)  $default,) {final _that = this;
switch (_that) {
case _CurrentRouter():
return $default(_that.routerItem,_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RouterItem routerItem,  String? token)?  $default,) {final _that = this;
switch (_that) {
case _CurrentRouter() when $default != null:
return $default(_that.routerItem,_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentRouter implements CurrentRouter {
  const _CurrentRouter({required this.routerItem, this.token});
  factory _CurrentRouter.fromJson(Map<String, dynamic> json) => _$CurrentRouterFromJson(json);

@override final  RouterItem routerItem;
@override final  String? token;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentRouter&&(identical(other.routerItem, routerItem) || other.routerItem == routerItem)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,routerItem,token);

@override
String toString() {
  return 'CurrentRouter(routerItem: $routerItem, token: $token)';
}


}

/// @nodoc
abstract mixin class _$CurrentRouterCopyWith<$Res> implements $CurrentRouterCopyWith<$Res> {
  factory _$CurrentRouterCopyWith(_CurrentRouter value, $Res Function(_CurrentRouter) _then) = __$CurrentRouterCopyWithImpl;
@override @useResult
$Res call({
 RouterItem routerItem, String? token
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
@override @pragma('vm:prefer-inline') $Res call({Object? routerItem = null,Object? token = freezed,}) {
  return _then(_CurrentRouter(
routerItem: null == routerItem ? _self.routerItem : routerItem // ignore: cast_nullable_to_non_nullable
as RouterItem,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CurrentMiddleware {

 MiddlewareItem get middlewareItem; List<String> get historyMiddlewareIDs; String get slideMiddlewareID;
/// Create a copy of CurrentMiddleware
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentMiddlewareCopyWith<CurrentMiddleware> get copyWith => _$CurrentMiddlewareCopyWithImpl<CurrentMiddleware>(this as CurrentMiddleware, _$identity);

  /// Serializes this CurrentMiddleware to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentMiddleware&&(identical(other.middlewareItem, middlewareItem) || other.middlewareItem == middlewareItem)&&const DeepCollectionEquality().equals(other.historyMiddlewareIDs, historyMiddlewareIDs)&&(identical(other.slideMiddlewareID, slideMiddlewareID) || other.slideMiddlewareID == slideMiddlewareID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,middlewareItem,const DeepCollectionEquality().hash(historyMiddlewareIDs),slideMiddlewareID);

@override
String toString() {
  return 'CurrentMiddleware(middlewareItem: $middlewareItem, historyMiddlewareIDs: $historyMiddlewareIDs, slideMiddlewareID: $slideMiddlewareID)';
}


}

/// @nodoc
abstract mixin class $CurrentMiddlewareCopyWith<$Res>  {
  factory $CurrentMiddlewareCopyWith(CurrentMiddleware value, $Res Function(CurrentMiddleware) _then) = _$CurrentMiddlewareCopyWithImpl;
@useResult
$Res call({
 MiddlewareItem middlewareItem, List<String> historyMiddlewareIDs, String slideMiddlewareID
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
@pragma('vm:prefer-inline') @override $Res call({Object? middlewareItem = null,Object? historyMiddlewareIDs = null,Object? slideMiddlewareID = null,}) {
  return _then(_self.copyWith(
middlewareItem: null == middlewareItem ? _self.middlewareItem : middlewareItem // ignore: cast_nullable_to_non_nullable
as MiddlewareItem,historyMiddlewareIDs: null == historyMiddlewareIDs ? _self.historyMiddlewareIDs : historyMiddlewareIDs // ignore: cast_nullable_to_non_nullable
as List<String>,slideMiddlewareID: null == slideMiddlewareID ? _self.slideMiddlewareID : slideMiddlewareID // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MiddlewareItem middlewareItem,  List<String> historyMiddlewareIDs,  String slideMiddlewareID)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentMiddleware() when $default != null:
return $default(_that.middlewareItem,_that.historyMiddlewareIDs,_that.slideMiddlewareID);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MiddlewareItem middlewareItem,  List<String> historyMiddlewareIDs,  String slideMiddlewareID)  $default,) {final _that = this;
switch (_that) {
case _CurrentMiddleware():
return $default(_that.middlewareItem,_that.historyMiddlewareIDs,_that.slideMiddlewareID);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MiddlewareItem middlewareItem,  List<String> historyMiddlewareIDs,  String slideMiddlewareID)?  $default,) {final _that = this;
switch (_that) {
case _CurrentMiddleware() when $default != null:
return $default(_that.middlewareItem,_that.historyMiddlewareIDs,_that.slideMiddlewareID);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentMiddleware implements CurrentMiddleware {
  const _CurrentMiddleware({required this.middlewareItem, required final  List<String> historyMiddlewareIDs, required this.slideMiddlewareID}): _historyMiddlewareIDs = historyMiddlewareIDs;
  factory _CurrentMiddleware.fromJson(Map<String, dynamic> json) => _$CurrentMiddlewareFromJson(json);

@override final  MiddlewareItem middlewareItem;
 final  List<String> _historyMiddlewareIDs;
@override List<String> get historyMiddlewareIDs {
  if (_historyMiddlewareIDs is EqualUnmodifiableListView) return _historyMiddlewareIDs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_historyMiddlewareIDs);
}

@override final  String slideMiddlewareID;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentMiddleware&&(identical(other.middlewareItem, middlewareItem) || other.middlewareItem == middlewareItem)&&const DeepCollectionEquality().equals(other._historyMiddlewareIDs, _historyMiddlewareIDs)&&(identical(other.slideMiddlewareID, slideMiddlewareID) || other.slideMiddlewareID == slideMiddlewareID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,middlewareItem,const DeepCollectionEquality().hash(_historyMiddlewareIDs),slideMiddlewareID);

@override
String toString() {
  return 'CurrentMiddleware(middlewareItem: $middlewareItem, historyMiddlewareIDs: $historyMiddlewareIDs, slideMiddlewareID: $slideMiddlewareID)';
}


}

/// @nodoc
abstract mixin class _$CurrentMiddlewareCopyWith<$Res> implements $CurrentMiddlewareCopyWith<$Res> {
  factory _$CurrentMiddlewareCopyWith(_CurrentMiddleware value, $Res Function(_CurrentMiddleware) _then) = __$CurrentMiddlewareCopyWithImpl;
@override @useResult
$Res call({
 MiddlewareItem middlewareItem, List<String> historyMiddlewareIDs, String slideMiddlewareID
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
@override @pragma('vm:prefer-inline') $Res call({Object? middlewareItem = null,Object? historyMiddlewareIDs = null,Object? slideMiddlewareID = null,}) {
  return _then(_CurrentMiddleware(
middlewareItem: null == middlewareItem ? _self.middlewareItem : middlewareItem // ignore: cast_nullable_to_non_nullable
as MiddlewareItem,historyMiddlewareIDs: null == historyMiddlewareIDs ? _self._historyMiddlewareIDs : historyMiddlewareIDs // ignore: cast_nullable_to_non_nullable
as List<String>,slideMiddlewareID: null == slideMiddlewareID ? _self.slideMiddlewareID : slideMiddlewareID // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CurrentPage {

 String get id; List<String> get path; String get name; String get icon; bool get isEditMode; List<String>? get widgetChildren;
/// Create a copy of CurrentPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentPageCopyWith<CurrentPage> get copyWith => _$CurrentPageCopyWithImpl<CurrentPage>(this as CurrentPage, _$identity);

  /// Serializes this CurrentPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentPage&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.path, path)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode)&&const DeepCollectionEquality().equals(other.widgetChildren, widgetChildren));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(path),name,icon,isEditMode,const DeepCollectionEquality().hash(widgetChildren));

@override
String toString() {
  return 'CurrentPage(id: $id, path: $path, name: $name, icon: $icon, isEditMode: $isEditMode, widgetChildren: $widgetChildren)';
}


}

/// @nodoc
abstract mixin class $CurrentPageCopyWith<$Res>  {
  factory $CurrentPageCopyWith(CurrentPage value, $Res Function(CurrentPage) _then) = _$CurrentPageCopyWithImpl;
@useResult
$Res call({
 String id, List<String> path, String name, String icon, bool isEditMode, List<String>? widgetChildren
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = null,Object? name = null,Object? icon = null,Object? isEditMode = null,Object? widgetChildren = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as List<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,widgetChildren: freezed == widgetChildren ? _self.widgetChildren : widgetChildren // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<String> path,  String name,  String icon,  bool isEditMode,  List<String>? widgetChildren)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentPage() when $default != null:
return $default(_that.id,_that.path,_that.name,_that.icon,_that.isEditMode,_that.widgetChildren);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<String> path,  String name,  String icon,  bool isEditMode,  List<String>? widgetChildren)  $default,) {final _that = this;
switch (_that) {
case _CurrentPage():
return $default(_that.id,_that.path,_that.name,_that.icon,_that.isEditMode,_that.widgetChildren);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<String> path,  String name,  String icon,  bool isEditMode,  List<String>? widgetChildren)?  $default,) {final _that = this;
switch (_that) {
case _CurrentPage() when $default != null:
return $default(_that.id,_that.path,_that.name,_that.icon,_that.isEditMode,_that.widgetChildren);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentPage implements CurrentPage {
  const _CurrentPage({required this.id, required final  List<String> path, required this.name, required this.icon, this.isEditMode = false, final  List<String>? widgetChildren}): _path = path,_widgetChildren = widgetChildren;
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
@override@JsonKey() final  bool isEditMode;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentPage&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._path, _path)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode)&&const DeepCollectionEquality().equals(other._widgetChildren, _widgetChildren));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_path),name,icon,isEditMode,const DeepCollectionEquality().hash(_widgetChildren));

@override
String toString() {
  return 'CurrentPage(id: $id, path: $path, name: $name, icon: $icon, isEditMode: $isEditMode, widgetChildren: $widgetChildren)';
}


}

/// @nodoc
abstract mixin class _$CurrentPageCopyWith<$Res> implements $CurrentPageCopyWith<$Res> {
  factory _$CurrentPageCopyWith(_CurrentPage value, $Res Function(_CurrentPage) _then) = __$CurrentPageCopyWithImpl;
@override @useResult
$Res call({
 String id, List<String> path, String name, String icon, bool isEditMode, List<String>? widgetChildren
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = null,Object? name = null,Object? icon = null,Object? isEditMode = null,Object? widgetChildren = freezed,}) {
  return _then(_CurrentPage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self._path : path // ignore: cast_nullable_to_non_nullable
as List<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,widgetChildren: freezed == widgetChildren ? _self._widgetChildren : widgetChildren // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
