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
    return GridView.builder(
      itemCount: widget.children.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.0),
      itemBuilder: (_, index) => widget.children[index],
    );
  }
}
