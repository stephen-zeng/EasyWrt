import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../router/router_controller.dart';
import '../items/router_dialog.dart';

/// RouterManagementPage
/// 
/// Function: Displays a list of managed routers and allows CRUD operations.
/// Inputs: None
/// Outputs: 
///   - [Widget]: List view of routers.
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
        : ListView.builder(
            itemCount: routers.length,
            itemBuilder: (context, index) {
              final router = routers[index];
              return ListTile(
                leading: const Icon(Icons.router),
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
          ),
    );
  }
}
