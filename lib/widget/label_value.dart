import 'package:FL_Foreman/res/text_styles.dart';
import 'package:flutter/material.dart';

class LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final double fontSize;
  const LabelValue({Key key, @required this.label, @required this.value, this.fontSize = 14}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyles.grey_14.copyWith(height: 1, fontSize: fontSize)),
        Text(value, style: TextStyles.black_14.copyWith(height: 1, fontSize: fontSize)),
      ],
    );
  }
}
