// src/modules/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../cubits/price_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crypto MVP')),
      body: BlocProvider(
        create: (_) => PriceCubit()..fetchPrices(),
        child: BlocBuilder<PriceCubit, PriceState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error.isNotEmpty) {
              return Center(child: Text('Erro: ${state.error}'));
            } else {
              return ListView.builder(
                itemCount: state.prices.length,
                itemBuilder: (context, index) {
                  final crypto = state.prices.keys.elementAt(index);
                  final price = state.prices[crypto];
                  return ListTile(
                    title: Text(crypto),
                    subtitle: Text('\$${price?.toStringAsFixed(2)}'),
                    onTap: () {
                      Modular.to.pushNamed('/details', arguments: {
                        'crypto': crypto,
                        'price': price,
                      });
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
