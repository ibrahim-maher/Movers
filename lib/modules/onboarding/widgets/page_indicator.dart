import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final Function(int)? onTap;
  final double dotSize;
  final double spacing;
  final Color? activeColor;
  final Color? inactiveColor;

  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    this.onTap,
    this.dotSize = 8.0,
    this.spacing = 8.0,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeClr = activeColor ?? Theme.of(context).colorScheme.primary;
    final inactiveClr = inactiveColor ??
        Theme.of(context).colorScheme.onSurface.withOpacity(0.3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
            (index) => GestureDetector(
          onTap: onTap != null ? () => onTap!(index) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            height: dotSize,
            width: currentIndex == index ? dotSize * 2.5 : dotSize,
            decoration: BoxDecoration(
              color: currentIndex == index ? activeClr : inactiveClr,
              borderRadius: BorderRadius.circular(dotSize / 2),
            ),
          ),
        ),
      ),
    );
  }
}