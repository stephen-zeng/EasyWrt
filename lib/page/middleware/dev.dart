import 'package:flutter/material.dart';
import 'package:easywrt/utils/wrt.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../widget/index.dart';

class ExampleDestination {
  const ExampleDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<ExampleDestination> destinations = <ExampleDestination>[
  ExampleDestination('Messages', Icon(Icons.widgets_outlined), Icon(Icons.widgets)),
  ExampleDestination('Profile', Icon(Icons.format_paint_outlined), Icon(Icons.format_paint)),
  ExampleDestination('Settings', Icon(Icons.settings_outlined), Icon(Icons.settings)),
];
class DevModule extends Module {
  @override
  void routes(r) {
    r.child(
        "/",
        child: (_) => const DevPage(),
        transition: TransitionType.fadeIn
    );
  }
}

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  late Future<List<dynamic>> _status;

  @override
  void initState() {
    super.initState();
    _status = Wrt.call(
      "afc63af0-fcc9-4f00-80d2-b28e5e08e5c0",
      [["network.interface", "dump"]],
    );
  }

  Widget getStatus(BuildContext context) {
    return FutureBuilder<String>(
      future: _status.then((value) => value.toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 加载中
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: Theme.of(context).textTheme.bodySmall,
          );
        } else {
          return Text(
            snapshot.data ?? 'No data',
            style: Theme.of(context).textTheme.bodySmall,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widgetIndex['memoryInfo']!;
    // return showNavigationDrawer ? buildDrawerScaffold(context) : buildBottomBarScaffold();
  }
}