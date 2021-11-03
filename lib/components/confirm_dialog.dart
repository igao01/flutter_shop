import 'package:flutter/material.dart';

class CustomConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function() positiveOnPressed;
  final Function() negativeOnPressed;

  const CustomConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.negativeOnPressed,
    required this.positiveOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text('Sim'),
          onPressed: positiveOnPressed,
        ),
        ElevatedButton(
          child: const Text('Não'),
          onPressed: negativeOnPressed,
        ),
      ],
    );
  }
}
