// src/app_module.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'modules/home/home_module.dart';
import 'modules/detail/detail_module.dart';
import 'cubits/alert_cubit.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton(
            (i) => AlertCubit()), // Registre o AlertCubit globalmente
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute(Modular.initialRoute, module: HomeModule()),
        ModuleRoute('/details', module: DetailModule()),
      ];
}
