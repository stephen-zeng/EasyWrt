import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../db/models/app_setting_item.dart';
import '../../router/router_controller.dart';
import '../items/router_dialog.dart';
import '../theme_provider.dart';

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
    final isConnecting = ref.watch(connectionLoadingProvider);

    return Scaffold(
      appBar: AppBar(
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
      body: isConnecting 
        ? const Center(child: CircularProgressIndicator())
        : ValueListenableBuilder<Box<AppSettingItem>>(
            valueListenable: Hive.box<AppSettingItem>('app_settings').listenable(),
            builder: (context, box, _) {
              final settings = box.get('default');
              final selectedId = settings?.lastConnectedRouterId;

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
                          final success = await ref.read(routerConnectionProvider).connect(router);
                          if (success) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Connected successfully')),
                              );
                              context.go('/router');
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to connect to router')),
                              );
                            }
                          }
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
                      final success = await ref.read(routerConnectionProvider).connect(router);
                      if (success) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Connected successfully')),
                          );
                          context.go('/router');
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to connect to router')),
                          );
                        }
                      }
                    },
                  );
                },
              );
            },
          ),
    );
  }
}
