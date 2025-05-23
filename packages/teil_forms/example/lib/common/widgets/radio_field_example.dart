import 'package:flutter/material.dart';
import 'package:teil_forms/teil_forms.dart';

class RadioFieldExample<T> extends StatelessWidget {
  final TeilFormField<T> field;

  final List<T> values;

  const RadioFieldExample({required this.values, required this.field, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorsScheme = Theme.of(context).colorScheme;

    return FieldBuilder(
      field: field,
      builder: (context, field) {
        TextStyle? titleStyle;
        if (field.errorText != null) {
          titleStyle = textTheme.bodyLarge?.copyWith(color: colorsScheme.error);
        }

        return Column(
          key: Key(field.key),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(values.length, (index) {
              final value = values[index];
              return RadioListTile<T>(
                key: ValueKey(value),
                fillColor: WidgetStateProperty.resolveWith((_) {
                  if (field.errorText != null) return colorsScheme.error;
                  return colorsScheme.primary;
                }),
                title: Text('Option $value', style: titleStyle),
                groupValue: field.value,
                value: value,
                onChanged: (value) => field.value = value as T,
                contentPadding: EdgeInsets.zero,
              );
            }),
            if (field.errorText != null) ...[
              const SizedBox(height: 8),
              Text(
                field.errorText!,
                style: textTheme.bodyMedium?.copyWith(color: colorsScheme.error),
              ),
            ],
          ],
        );
      },
    );
  }
}
