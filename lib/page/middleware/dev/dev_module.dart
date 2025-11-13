import './dev.dart';
import 'package:flutter_modular/flutter_modular.dart';

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