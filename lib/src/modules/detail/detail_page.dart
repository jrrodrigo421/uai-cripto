// src/modules/detail/detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/alert_cubit.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailPage(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String crypto = data['crypto'];
    final double price = data['price'];
    final alertCubit = context.read<AlertCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(crypto)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$crypto Details',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text('Current Price: \$${price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            BlocBuilder<AlertCubit, AlertState>(
              builder: (context, state) {
                final alertPrice = state.alerts[crypto];
                return Column(
                  children: [
                    if (alertPrice != null)
                      Text('Alert Set: \$${alertPrice.toStringAsFixed(2)}'),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Set Alert Price'),
                      onSubmitted: (value) {
                        final targetPrice = double.tryParse(value);
                        if (targetPrice != null) {
                          alertCubit.addAlert(crypto, targetPrice);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
