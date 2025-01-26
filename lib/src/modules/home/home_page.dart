// src/modules/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../cubits/price_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro sofisticado
      appBar: AppBar(
        title: const Text(
          'UAI Crypto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => PriceCubit()..fetchPrices(),
        child: BlocBuilder<PriceCubit, PriceState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              );
            } else if (state.error.isNotEmpty) {
              return Center(
                child: Text(
                  'Erro: ${state.error}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width > 600 ? 3 : 2, // Responsivo
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.prices.length,
                  itemBuilder: (context, index) {
                    final crypto = state.prices.keys.elementAt(index);
                    final price = state.prices[crypto];
                    return GestureDetector(
                      onTap: () {
                        Modular.to.pushNamed('/details', arguments: {
                          'crypto': crypto,
                          'price': price,
                        });
                      },
                      child: Card(
                        color: const Color(0xFF1E1E1E), // Fundo do card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.monetization_on,
                                size: 40,
                                color: Colors.amber,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                crypto,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${price?.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
