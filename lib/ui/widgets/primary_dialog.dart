import 'package:flutter/material.dart';

class PrimaryDialog extends StatelessWidget {
  final Widget child;

  const PrimaryDialog({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
