import 'package:flutter/material.dart';

typedef OmniGridItemBuilder = Widget Function(BuildContext context, int index);

class OmniGrid extends StatefulWidget {
  const OmniGrid({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  State<OmniGrid> createState() => _OmniGridState();
}

class _OmniGridState extends State<OmniGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.of(context).size.width;
    final viewportHeight = MediaQuery.of(context).size.height;
    final crossAxisCount = 3;
    final mainAxisCount = (widget.children.length / crossAxisCount).ceil();
    final gridWidth = viewportWidth * crossAxisCount;
    final gridHeight = viewportHeight * mainAxisCount;
    return SizedBox(
      width: gridWidth,
      height: gridHeight,
      child: GridView.builder(
        itemCount: widget.children.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: viewportWidth / viewportHeight,
        ),
        itemBuilder: (_, index) => widget.children[index],
      ),
    );
  }
}
