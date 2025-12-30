import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easywrt/modules/setting/controller/router_list_controller.dart';
import 'package:easywrt/modules/router/controllers/current_router_controller.dart';
import 'package:easywrt/modules/router/controllers/connection_controller.dart';
import 'package:easywrt/modules/setting/theme/theme_provider.dart';
import 'package:easywrt/modules/setting/items/router_dialog.dart';
import 'package:easywrt/beam/window/responsive_layout.dart';

/// RouterManagementPage
/// RouterManagementPage
///
/// Function: Displays a list of managed routers and allows CRUD operations.
/// Function: 显示受管路由器列表并允许 CRUD 操作。
/// Inputs: None
/// Inputs: 无
/// Outputs:
/// Outputs:
///   - [Widget]: List view of routers.
///   - [Widget]: 路由器列表视图。
class RouterManagementPage extends ConsumerWidget {
  const RouterManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routers = ref.watch(routerListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: !ResponsiveLayout.isLandscape(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.go('/setting');
                },
              )
            : null,
        title: const Text('Manage Routers'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const RouterDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(
            builder: (context) {
              final currentRouter = ref.watch(currentRouterProvider);
              final selectedId = currentRouter?.routerItem.id;

              return ListView.builder(
                itemCount: routers.length,
                itemBuilder: (context, index) {
                  final router = routers[index];
                  return ListTile(
                    leading: Radio<String>(
                      value: router.id,
                      groupValue: selectedId,
                      onChanged: (value) async {
                        if (value != null) {
                          ref.read(currentRouterProvider.notifier).selectRouter(router);
                          // Explicitly save last connected router ID
                          await ref.read(themeRepositoryProvider).updateLastConnectedRouter(router.id);
                          // Connect immediately
                          await ref.read(routerConnectionProvider).connect(router);
                        }
                      },
                    ),
                    title: Text(router.name),
                    subtitle: Text('${router.host}:${router.port}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => RouterDialog(router: router),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            ref.read(routerListProvider.notifier).deleteRouter(router.id);
                          },
                        ),
                      ],
                    ),
                    onTap: () async {
                      ref.read(currentRouterProvider.notifier).selectRouter(router);
                      // Explicitly save last connected router ID
                      await ref.read(themeRepositoryProvider).updateLastConnectedRouter(router.id);
                      // Connect immediately
                      await ref.read(routerConnectionProvider).connect(router);
                    },
                  );
                },
              );
            },
          ),
    );
  }
}
