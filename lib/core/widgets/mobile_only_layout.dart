import 'package:flutter/material.dart';

class MobileOnlyLayout extends StatelessWidget {
  final Widget child;

  const MobileOnlyLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: child,
      ),
    );
  }
}
