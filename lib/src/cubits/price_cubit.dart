// src/cubits/price_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PriceState {
  final Map<String, double> prices;
  final bool isLoading;
  final String error;

  PriceState({
    required this.prices,
    required this.isLoading,
    required this.error,
  });

  factory PriceState.initial() {
    return PriceState(prices: {}, isLoading: false, error: '');
  }
}

class PriceCubit extends Cubit<PriceState> {
  PriceCubit() : super(PriceState.initial());

  Future<void> fetchPrices() async {
    emit(PriceState(prices: {}, isLoading: true, error: ''));

    try {
      final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum&vs_currencies=usd'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final prices = {
          'Bitcoin': data['bitcoin']['usd'] as double,
          'Ethereum': data['ethereum']['usd'] as double,
        };
        emit(PriceState(prices: prices, isLoading: false, error: ''));
      } else {
        emit(PriceState(prices: {}, isLoading: false, error: 'Erro ao buscar preços.'));
      }
    } catch (e) {
      emit(PriceState(prices: {}, isLoading: false, error: e.toString()));
    }
  }
}
