// src/modules/detail/detail_module.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'detail_page.dart';
import '../../cubits/alert_cubit.dart';

class DetailModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, args) => BlocProvider.value(
            value: Modular.get<AlertCubit>(), // Obtém o AlertCubit global
            child: DetailPage(args.data),
          ),
        ),
      ];
}
