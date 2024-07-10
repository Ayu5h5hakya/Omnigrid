import 'package:flutter/material.dart';

typedef OmniGridItemBuilder = Widget Function(BuildContext context, int index);

class OmniGrid extends StatefulWidget {
  const OmniGrid({
    super.key,
    required this.children,
    required this.width,
    required this.height,
    this.crossAxisCount = 3,
    this.startIndex = 0,
  });

  final List<Widget> children;
  final double width;
  final double height;
  final int crossAxisCount;
  final int startIndex;

  @override
  State<OmniGrid> createState() => _OmniGridState();
}

class _OmniGridState extends State<OmniGrid> {
  Duration _animationDuration = Duration.zero;
  late final ValueNotifier<Offset> _gridOffsetNotifier;
  Offset _panStartOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    final initialOffset = _mapIndexToOffset(widget.startIndex);
    _gridOffsetNotifier = ValueNotifier<Offset>(initialOffset);
  }

  @override
  Widget build(BuildContext context) {
    final mainAxisCount =
        (widget.children.length / widget.crossAxisCount).ceil();
    final gridWidth = widget.width * widget.crossAxisCount;
    final gridHeight = widget.height * mainAxisCount;
    return ValueListenableBuilder(
      valueListenable: _gridOffsetNotifier,
      builder: (context, Offset gridOffset, child) {
        return TweenAnimationBuilder(
          duration: _animationDuration,
          curve: Curves.easeOutSine,
          tween: Tween<Offset>(begin: Offset.zero, end: gridOffset),
          builder: (context, Offset offset, Widget? child) {
            return Transform(
              transform: Matrix4.identity()
                ..setTranslationRaw(offset.dx, offset.dy, 0),
              child: child,
            );
          },
          child: child,
        );
      },
      child: SizedBox(
        width: gridWidth,
        height: gridHeight,
        child: GridView.builder(
          itemCount: widget.children.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            childAspectRatio: widget.width / widget.height,
          ),
          itemBuilder: (_, index) => widget.children[index],
        ),
      ),
    );
  }

  Offset _mapIndexToOffset(int index) {
    final xViewports = index % widget.crossAxisCount;
    final yViewports = index ~/ widget.crossAxisCount;
    return Offset(
      -xViewports * widget.width,
      -yViewports * widget.height,
    );
  }
}
