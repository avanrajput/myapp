import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  const CustomCard({
    super.key,
    required this.child,
    this.borderRadius = 15.0,
    this.borderColor = Colors.green,
    this.backgroundColor = Colors.black,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: child,
    );
  }
}
