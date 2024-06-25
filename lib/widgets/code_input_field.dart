import 'package:flutter/material.dart';

class CodeInputField extends StatelessWidget {
  final List<TextEditingController> controllers;
  final int numberOfFields;
  final double fieldWidth;
  final double fieldHeight;
  final double borderRadius;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double fieldSpacing;

  const CodeInputField({
    Key? key,
    required this.controllers,
    this.numberOfFields = 4,
    this.fieldWidth = 60.0,
    this.fieldHeight = 60.0,
    this.borderRadius = 5.0,
    this.backgroundColor = Colors.grey,
    this.textStyle = const TextStyle(fontSize: 24.0),
    this.fieldSpacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numberOfFields * 2 - 1, (index) {
        if (index % 2 == 0) {
          int fieldIndex = index ~/ 2;
          return Container(
            width: fieldWidth,
            height: fieldHeight,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: TextField(
              controller: controllers[fieldIndex],
              maxLength: 1,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: textStyle,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          );
        } else {
          return SizedBox(width: fieldSpacing);
        }
      }),
    );
  }
}
