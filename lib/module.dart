import 'package:easywrt/page/index_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(i) {}
  
  @override
  void routes(r) {
    r.module("/", module: IndexModule());
  }
}