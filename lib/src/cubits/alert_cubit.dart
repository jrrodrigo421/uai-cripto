// src/cubits/alert_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertState {
  final Map<String, double> alerts;

  AlertState(this.alerts);

  factory AlertState.initial() => AlertState({});
}

class AlertCubit extends Cubit<AlertState> {
  AlertCubit() : super(AlertState.initial());

  void addAlert(String crypto, double targetPrice) {
    final updatedAlerts = Map<String, double>.from(state.alerts);
    updatedAlerts[crypto] = targetPrice;
    emit(AlertState(updatedAlerts));
  }

  void removeAlert(String crypto) {
    final updatedAlerts = Map<String, double>.from(state.alerts);
    updatedAlerts.remove(crypto);
    emit(AlertState(updatedAlerts));
  }
}
