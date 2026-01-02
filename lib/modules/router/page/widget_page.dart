import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easywrt/beam/widget/grid_size_scope.dart';
import 'package:easywrt/modules/router/controllers/widget_catalog_controller.dart';
import 'package:easywrt/modules/router/widgets/base/base_widget.dart';
import 'package:easywrt/beam/window/responsive_layout.dart';

class WidgetPage extends ConsumerWidget {
  final String pageId;

  const WidgetPage({
    super.key,
    required this.pageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // pageId format: widget_{typeKey}
    if (!pageId.startsWith('widget_')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Invalid Widget Page ID')),
      );
    }

    final typeKey = pageId.replaceFirst('widget_', '');
    final catalog = ref.watch(widgetCatalogProvider);
    
    BaseWidget? widgetInstance;
    try {
      widgetInstance = catalog.firstWhere((w) => w.typeKey == typeKey);
    } catch (_) {
      widgetInstance = null;
    }

    if (widgetInstance == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: Center(child: Text('Widget type "$typeKey" not found in catalog')),
      );
    }

    final isLandscape = ResponsiveLayout.isLandscape(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widgetInstance.name),
        leading: isLandscape ? null : const BackButton(),
      ),
      body: GridSizeScope(
        width: 0,
        height: 0,
        child: widgetInstance,
      ),
    );
  }
}
