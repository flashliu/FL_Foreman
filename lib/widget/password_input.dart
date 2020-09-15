import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final Function(String value) onFinsh;
  PasswordInput({Key key, this.onFinsh}) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  String value = '';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List(6)
              .asMap()
              .keys
              .map(
                (i) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: InputBox(hasValue: value.length >= i + 1),
                  ),
                ),
              )
              .toList(),
        ),
        Opacity(
          opacity: 0,
          child: TextField(
            autofocus: true,
            showCursor: false,
            keyboardType: TextInputType.number,
            onChanged: (text) {
              if (text.length == 6) {
                widget.onFinsh(text);
              }
              setState(() {
                value = text;
              });
            },
          ),
        ),
      ],
    );
  }
}

class InputBox extends StatelessWidget {
  final bool hasValue;
  const InputBox({
    Key key,
    this.hasValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Text(hasValue ? '●' : ''),
      color: Color(0xFFE2E2E2),
      alignment: Alignment.center,
    );
  }
}
