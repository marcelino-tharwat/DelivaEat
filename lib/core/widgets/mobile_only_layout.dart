import 'package:flutter/material.dart';

class MobileOnlyLayout extends StatelessWidget {
  final Widget child;

  const MobileOnlyLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth < 600.0
        ? screenWidth
        : (screenWidth < 1200.0 ? 800.0 : 1200.0);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
