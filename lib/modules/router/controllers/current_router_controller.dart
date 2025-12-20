import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/db/models/transient_models.dart';
import 'package:easywrt/db/interface/router_repository.dart';
import 'package:easywrt/modules/setting/theme/theme_provider.dart';
import 'package:easywrt/db/models/router_item.dart';

// Repository Provider
final routerRepositoryProvider = Provider<RouterRepository>((ref) {
  return RouterRepository();
});

class CurrentRouterNotifier extends StateNotifier<CurrentRouter?> {
  final Ref ref;

  CurrentRouterNotifier(this.ref) : super(null) {
    _init();
  }

  void _init() {
    final themeRepo = ref.read(themeRepositoryProvider);
    final settings = themeRepo.getSettings();
    final lastId = settings?.lastConnectedRouterId;

    if (lastId != null) {
      final routerRepo = ref.read(routerRepositoryProvider);
      final routers = routerRepo.getAllRouters();
      try {
        final routerItem = routers.firstWhere((element) => element.id == lastId);
        state = CurrentRouter(
          routerItem: routerItem,
          token: null,
        );
      } catch (e) {
        // Router might have been deleted
        state = null;
      }
    }
  }

  void selectRouter(RouterItem routerItem, {String? newToken}) {
    // If we are switching to a different router, we usually want to clear the old token
    // unless a new token is explicitly provided. 
    // However, the original logic preserved the token if newToken was null and we were potentially
    // just updating the router item itself (or re-selecting same?).
    // Let's stick to the previous logic but be careful.
    
    // Original logic:
    // final oldCurrentRouter = ref.read(currentRouterProvider);
    // final String? tokenToUse = newToken ?? oldCurrentRouter?.token;
    
    // Logic adaptation:
    // If newToken is provided, use it.
    // If not, try to keep existing token ONLY if we are updating the SAME router or if logic dictates.
    // But typically 'selectRouter' implies switching. 
    // If we switch routers, the old token is invalid.
    
    // However, the original code blindly took `oldCurrentRouter?.token`. 
    // If I switch from Router A to Router B, preserving Router A's token for Router B is likely wrong.
    // But let's look at how it's used.
    // 1. Router Management Page: `await ref.read(routerConnectionProvider).selectRouter(router);`
    //    Here newToken is null. It switches context. Preserving token seems wrong if switching routers.
    // 2. Connection Controller: `await selectRouter(routerItem, newToken: session);`
    //    Here newToken is provided.
    
    // Refined Logic:
    // If switching to a NEW router (different ID), default token to null unless provided.
    // If updating SAME router, preserve token unless provided.
    
    String? tokenToUse = newToken;
    if (tokenToUse == null && state != null && state!.routerItem.id == routerItem.id) {
       tokenToUse = state!.token;
    }

    state = CurrentRouter(
      routerItem: routerItem,
      token: tokenToUse,
    );
  }

  void updateRouterItem(RouterItem item) {
    if (state != null && state!.routerItem.id == item.id) {
      state = state!.copyWith(routerItem: item);
    }
  }

  void clear() {
    state = null;
  }
}

// Current Router State
final currentRouterProvider = StateNotifierProvider<CurrentRouterNotifier, CurrentRouter?>((ref) {
  return CurrentRouterNotifier(ref);
});
