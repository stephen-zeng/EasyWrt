// learning for kazumi, big thanks to their team!
// works for flutter dialog management with context handling
import 'package:flutter/material.dart';

import '../../config/meta.dart';

class SZDialog {
  static final SZDialogObserver observer = SZDialogObserver();
  SZDialog._internal();
  static Future<T?> show<T>({
    BuildContext? context,
    bool? clickMaskDismiss,
    VoidCallback? onDismiss,
    required WidgetBuilder builder,
  }) async {
    final ctx = context ?? observer.currentContext;
    if (ctx != null && ctx.mounted) {
      try {
        final result = await showDialog<T>(
          context: ctx,
          barrierDismissible: clickMaskDismiss ?? true,
          builder: builder,
          routeSettings: const RouteSettings(name: 'SZDialog'),
        );
        onDismiss?.call();
        return result;
      } catch (e) {
        debugPrint('SZ Dialog Error: Failed to show dialog: $e');
        return null;
      }
    } else {
      debugPrint(
          'SZ Dialog Error: No context available to show the dialog');
      return null;
    }
  }

  static void showToast({
    required String message,
    BuildContext? context,
    bool showActionButton = false,
    String? actionLabel,
    Function()? onActionPressed,
    Duration duration = const Duration(seconds: 2),
  }) {
    final ctx = context ?? observer.scaffoldContext;
    if (ctx != null && ctx.mounted) {
      try {
        ScaffoldMessenger.of(ctx)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
              width: MediaQuery.sizeOf(ctx).width >
                  Meta.compactWindowSize['width']!
                  ? 600
                  : null,
              duration: duration,
              action: showActionButton
                  ? SnackBarAction(
                label: actionLabel ?? 'Dismiss',
                onPressed: () {
                  onActionPressed?.call();
                  ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
                },
              )
                  : null,
            ),
          );
      } catch (e) {
        debugPrint('SZ Dialog Error: Failed to show toast: $e');
      }
    } else {
      debugPrint(
          'SZ Dialog Error: No Scaffold context available to show Toast');
    }
  }

  static Future<void> showLoading({
    BuildContext? context,
    String? msg,
    bool barrierDismissible = false,
    Function()? onDismiss,
  }) async {
    final ctx = context ?? observer.currentContext;
    if (ctx != null && ctx.mounted) {
      try {
        await showDialog(
          context: ctx,
          barrierDismissible: barrierDismissible,
          builder: (BuildContext context) {
            return Center(
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        msg ?? 'Loading...',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          routeSettings: const RouteSettings(name: 'SZDialog'),
        );
        onDismiss?.call();
      } catch (e) {
        debugPrint('SZ Dialog Error: Failed to show loading dialog: $e');
      }
    } else {
      debugPrint(
          'SZ Dialog Error: No context available to show the loading dialog');
    }
  }

  static Future<T?> showBottomSheet<T>({
    BuildContext? context,
    required WidgetBuilder builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = true,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
    bool useSafeArea = false,
  }) async {
    final ctx = context ?? observer.rootContext ?? observer.currentContext;
    if (ctx != null && ctx.mounted) {
      try {
        final result = await showModalBottomSheet<T>(
          context: ctx,
          builder: builder,
          backgroundColor: backgroundColor,
          elevation: elevation,
          shape: shape,
          clipBehavior: clipBehavior,
          constraints: constraints,
          barrierColor: barrierColor,
          isScrollControlled: isScrollControlled,
          useRootNavigator: useRootNavigator,
          isDismissible: isDismissible,
          enableDrag: enableDrag,
          routeSettings:
          routeSettings ?? const RouteSettings(name: 'SZBottomSheet'),
          transitionAnimationController: transitionAnimationController,
          anchorPoint: anchorPoint,
          useSafeArea: useSafeArea,
        );
        return result;
      } catch (e) {
        debugPrint('SZ Dialog Error: Failed to show bottom sheet: $e');
        return null;
      }
    } else {
      debugPrint(
          'SZ Dialog Error: No context available to show the bottom sheet');
      return null;
    }
  }

  // 在存在返回值时弹出并附带返回值
  static void dismiss<T>({T? popWith}) {
    if (observer.hasSZDialog && observer.SZDialogContext != null) {
      try {
        Navigator.of(observer.SZDialogContext!).pop(popWith);
      } catch (e) {
        debugPrint('SZ Dialog Error: Failed to dismiss dialog: $e');
      }
    } else {
      debugPrint('SZ Dialog Debug: No active SZDialog to dismiss');
    }
  }
}

class SZDialogObserver extends NavigatorObserver {
  final List<Route<dynamic>> _SZDialogRoutes = [];

  BuildContext? _currentContext;
  BuildContext? _scaffoldContext;
  BuildContext? _rootContext;
  BuildContext? get currentContext => _currentContext;
  BuildContext? get scaffoldContext => _scaffoldContext ?? _currentContext;
  BuildContext? get rootContext => _rootContext ?? _scaffoldContext ?? _currentContext;

  bool get hasSZDialog => _SZDialogRoutes.isNotEmpty;
  BuildContext? get SZDialogContext =>
      _SZDialogRoutes.isNotEmpty ? _SZDialogRoutes.last.navigator?.context : null;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (_isSZDialogRoute(route)) {
      _SZDialogRoutes.add(route);
    }
    if (route.navigator?.context != null) {
      _updateContexts(route.navigator!.context, route);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _removeCurrentSnackBar(route);
    if (_isSZDialogRoute(route)) {
      _SZDialogRoutes.remove(route);
    }
    if (previousRoute?.navigator?.context != null) {
      _updateContexts(previousRoute!.navigator!.context, previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (_isSZDialogRoute(oldRoute!)) {
      _SZDialogRoutes.remove(oldRoute);
    }
    if (_isSZDialogRoute(newRoute!)) {
      _SZDialogRoutes.add(newRoute);
    }
    if (newRoute.navigator?.context != null) {
      _updateContexts(newRoute.navigator!.context, newRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);

    if (_isSZDialogRoute(route)) {
      _SZDialogRoutes.remove(route);
    }

    if (previousRoute?.navigator?.context != null) {
      _updateContexts(previousRoute!.navigator!.context, previousRoute);
    }
  }

  void _updateContexts(BuildContext context, Route<dynamic> route) {
    _currentContext = context;
    if (_hasScaffold(context)) {
      _scaffoldContext = context;
      _rootContext = context;
    }
  }

  bool _hasScaffold(BuildContext context) {
    return Scaffold.maybeOf(context) != null;
  }

  bool _isSZDialogRoute(Route<dynamic> route) {
    return route.settings.name == 'SZDialog' ||
        route.settings.name == 'SZBottomSheet';
  }

  void _removeCurrentSnackBar(Route<dynamic>? route) {
    if (route?.navigator?.context != null) {
      try {
        ScaffoldMessenger.maybeOf(route!.navigator!.context)
            ?.removeCurrentSnackBar();
      } catch (_) {}
    }
  }
}