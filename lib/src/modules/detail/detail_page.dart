// src/modules/detail/detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../cubits/alert_cubit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailPage(this.data, {super.key});

  Future<List<PriceData>> fetchHistoricalData(String cryptoId) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/$cryptoId/market_chart?vs_currency=usd&days=7',
        ),
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final prices = decoded['prices'] as List<dynamic>;
        return prices
            .map((price) => PriceData(
                  DateTime.fromMillisecondsSinceEpoch(price[0]),
                  price[1],
                ))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching historical data: $e');
    }
    return []; // Retorna vazio se ocorrer algum erro
  }

  @override
  Widget build(BuildContext context) {
    final String crypto = data['crypto'];
    final double price = data['price'];
    final String cryptoId = crypto.toLowerCase(); // Identificador para a API

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro sofisticado
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.of(context).pop(), // Voltar para a página anterior
        ),
        title: Text(
          crypto,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preço Atual
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Valor Atual',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Criar Alerta
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<AlertCubit, AlertState>(
                  builder: (context, state) {
                    final alertPrice = state.alerts[crypto];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Configure o alerta de preço',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (alertPrice != null)
                          Text(
                            'Valor cofigurado: \$${alertPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        TextField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Digite o valor do preço',
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                          ),
                          onSubmitted: (value) {
                            final targetPrice = double.tryParse(value);
                            if (targetPrice != null) {
                              context.read<AlertCubit>().addAlert(
                                    crypto,
                                    targetPrice,
                                  );
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Gráfico de Histórico de Preços
            Expanded(
              child: FutureBuilder<List<PriceData>>(
                future: fetchHistoricalData(cryptoId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    );
                  } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Error loading data',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    );
                  } else {
                    final data = snapshot.data!;
                    return Card(
                      color: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SfCartesianChart(
                          backgroundColor: const Color(0xFF1E1E1E),
                          primaryXAxis: DateTimeAxis(
                            majorGridLines: const MajorGridLines(width: 0),
                            axisLine: const AxisLine(width: 0.5),
                          ),
                          primaryYAxis: NumericAxis(
                            majorGridLines: const MajorGridLines(width: 0.5),
                            axisLine: const AxisLine(width: 0.5),
                          ),
                          series: <ChartSeries>[
                            LineSeries<PriceData, DateTime>(
                              dataSource: data,
                              xValueMapper: (PriceData point, _) => point.time,
                              yValueMapper: (PriceData point, _) => point.price,
                              color: Colors.amber,
                              width: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modelo para dados de preço
class PriceData {
  final DateTime time;
  final double price;

  PriceData(this.time, this.price);
}
