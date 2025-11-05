import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../database/device.dart';
import 'dev.dart';
import 'index.dart';
import 'init.dart';

class IndexModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(DeviceController.new);
  }

  @override
  void routes(r) {
    r.child(
      "/",
      child: (_) => const InitPage(), 
      children: [
        ChildRoute("/error", child: (_) => Scaffold(
            appBar: AppBar(title: const Text("EasyWRT")),
            body: const Center(child: Text("初始化失败")),
          ),
        ),
      ],
      transition: TransitionType.fadeIn
    );

    r.child(
      "/tab",
      child: (_) {
        return const IndexPage();
      },
    );

    r.child(
      "/dev",
      child: (_) => const DevPage(),
      transition: TransitionType.fadeIn
    );
  }
}