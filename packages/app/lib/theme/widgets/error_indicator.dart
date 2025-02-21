import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    required this.title,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          child: IntrinsicWidth(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: colorScheme.onError),
                  const SizedBox(width: 10),
                  Text(title, style: TextStyle(color: colorScheme.onError)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: onPressed,
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          child: Text(label),
        ),
      ],
    );
  }
}
