// src/modules/home/home_module.dart
import 'package:crypto_mvp/src/cubits/price_cubit.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => PriceCubit()), // Registro do PriceCubit
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const HomePage()),
      ];
}
