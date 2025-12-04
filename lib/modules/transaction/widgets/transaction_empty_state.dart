import 'package:flutter/material.dart';

class TransactionEmptyState extends StatelessWidget {
  const TransactionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(child: Text('Nenhuma transação encontrada.')),
    );
  }
}
