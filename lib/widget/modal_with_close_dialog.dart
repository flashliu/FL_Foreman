import 'package:FL_Foreman/res/svgs.dart';
import 'package:flutter/material.dart';

class ModalWithCloseDialog extends StatelessWidget {
  final Widget child;
  ModalWithCloseDialog({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Center(
            child: child,
          ),
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Svgs.close,
        )
      ],
    );
  }
}
