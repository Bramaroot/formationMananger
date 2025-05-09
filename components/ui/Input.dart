import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String? type;
  final String? placeholder;
  final String value;
  final Function(String) onChange;
  final String? className;
  final String? id;
  final String? name;
  final bool required;

  const Input({
    Key? key,
    this.type,
    this.placeholder,
    required this.value,
    required this.onChange,
    this.className,
    this.id,
    this.name,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: placeholder,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onChanged: onChange,
      controller: TextEditingController(text: value),
    );
  }
}
