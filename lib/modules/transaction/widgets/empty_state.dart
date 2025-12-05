import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String textMessage;

  const EmptyState({super.key, required this.textMessage});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(textMessage));
  }
}
