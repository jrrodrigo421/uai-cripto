// src/modules/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../cubits/price_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Duration> intervals = [
    Duration(minutes: 1),
    Duration(minutes: 2),
    Duration(minutes: 5),
    Duration(minutes: 30),
    Duration(hours: 1),
  ];
  late Duration selectedInterval;
  late final PriceCubit priceCubit;

  @override
  void initState() {
    super.initState();
    priceCubit = Modular.get<PriceCubit>(); // Obtém o PriceCubit via Modular
    selectedInterval = intervals[0]; // Intervalo padrão: 1 minuto
    priceCubit.fetchPrices();
    priceCubit.startAutoRefresh(selectedInterval);
  }

  @override
  void dispose() {
    priceCubit.stopAutoRefresh(); // Cancela o timer ao sair da página
    super.dispose();
  }

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
        actions: [
          PopupMenuButton<Duration>(
            icon: const Icon(Icons.timer, color: Colors.white),
            onSelected: (interval) {
              setState(() {
                selectedInterval = interval;
              });
              priceCubit.startAutoRefresh(selectedInterval);
            },
            itemBuilder: (context) {
              return intervals
                  .map((interval) => PopupMenuItem(
                        value: interval,
                        child: Text(
                          interval.inMinutes < 60
                              ? '${interval.inMinutes} min'
                              : '${interval.inHours} hr',
                        ),
                      ))
                  .toList();
            },
          ),
        ],
      ),
      body: StreamBuilder<PriceState>(
        stream: priceCubit.stream,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state == null || state.isLoading) {
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
    );
  }
}
