import 'package:flutter/material.dart';

class const AppCheckbox({
  required final bool value,
  required final ValueChanged<bool?> onChanged,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkResponse(
      radius: 24,
      onTap: () => onChanged(!value),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(24),
          color: value ? colorScheme.primary : Colors.transparent,
          child: SizedBox(
            width: 24,
            height: 24,
            child: Visibility(
              visible: value,
              child: Icon(Icons.check, size: 14, color: colorScheme.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
