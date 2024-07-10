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
    this.snapDuration = const Duration(milliseconds: 300),
    this.snap = true,
    this.onStart,
    this.onUpdate,
    this.onEnd,
  });

  final List<Widget> children;
  final bool snap;
  final double width;
  final double height;
  final int crossAxisCount;
  final int startIndex;
  final Duration snapDuration;
  final VoidCallback? onStart;
  final VoidCallback? onUpdate;
  final Function(int)? onEnd;

  int get mainAxisCount => (children.length / crossAxisCount).ceil();
  double get gridWidth => width * crossAxisCount;
  double get gridHeight => height * mainAxisCount;

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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: OverflowBox(
        maxHeight: double.infinity,
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: ValueListenableBuilder(
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

  int _mapOffsetToIndex(Offset offset) {
    final xIndex = offset.dx.abs() ~/ widget.width;
    final yIndex = offset.dy.abs() ~/ widget.height;
    return yIndex * widget.crossAxisCount + xIndex;
  }

  void _onPanStart(DragStartDetails details) {
    _panStartOffset = _gridOffsetNotifier.value;
    widget.onStart?.call();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final newOffset = _gridOffsetNotifier.value + details.delta;
    final lower = Offset(
      -(widget.gridWidth - widget.width),
      -(widget.gridHeight - widget.height),
    );
    final clampedOffset = Offset(
      newOffset.dx.clamp(lower.dx, 0.0),
      newOffset.dy.clamp(lower.dy, 0.0),
    );
    _gridOffsetNotifier.value = clampedOffset;
    widget.onUpdate?.call();
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    widget.onEnd?.call(_mapOffsetToIndex(_gridOffsetNotifier.value));
    if (widget.snap) {
      final panEndOffset = _gridOffsetNotifier.value;

      _animationDuration = widget.snapDuration;
      _gridOffsetNotifier.value = _calculatePanEndGridOffset(
        _panStartOffset,
        panEndOffset,
      );

      await Future<dynamic>.delayed(_animationDuration);
      _animationDuration = Duration.zero;
    }
  }

  Offset _calculatePanEndGridOffset(
    Offset panStartOffset,
    Offset panEndOffset, {
    double tolerance = 15.0,
  }) {
    final pannedViewports = _calculatePannedViewports(
      panStartOffset,
      panEndOffset,
      Size(widget.width, widget.height),
      tolerance: tolerance,
    );

    return Offset(
      pannedViewports.dx * widget.width,
      pannedViewports.dy * widget.height,
    );
  }

  Offset _calculatePannedViewports(
    Offset panStartOffset,
    Offset panEndOffset,
    Size viewportSize, {
    double tolerance = 15.0,
  }) {
    final panDelta = panEndOffset - panStartOffset;

    final offset = Offset(
      panEndOffset.dx / widget.width,
      panEndOffset.dy / widget.height,
    );

    final dTolerance = Offset(
      panDelta.dx.abs() / panDelta.dx * tolerance,
      panDelta.dy.abs() / panDelta.dy * tolerance,
    );

    return Offset(
      panDelta.dx < dTolerance.dx
          ? offset.dx.floorToDouble()
          : offset.dx.ceilToDouble(),
      panDelta.dy < dTolerance.dy
          ? offset.dy.floorToDouble()
          : offset.dy.ceilToDouble(),
    );
  }
}
