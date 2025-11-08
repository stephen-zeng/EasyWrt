import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../utils/macos_safe.dart';
import 'base_route.dart';

class MiddlewareFrame extends StatefulWidget {
  const MiddlewareFrame({super.key});

  @override
  State<MiddlewareFrame> createState() => _MiddlewareFrameState();
}

class _MiddlewareFrameState extends State<MiddlewareFrame> {
  @override
  Widget build(BuildContext context) {
    return EmbeddedNativeControlArea(
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: MaterialLocalizations.of(context)
                        .openAppDrawerTooltip,
                  );
                }
            ),
            title: const Text('EasyWRT'),
          ),
          drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ...baseRoute.listTileList
                ],
              )
          ),
          body: const RouterOutlet(),
        )
    );
  }
}