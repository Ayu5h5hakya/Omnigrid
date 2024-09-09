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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GridView.builder(
      itemCount: widget.children.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: width / height,
      ),
      itemBuilder: (_, index) => widget.children[index],
    );
  }
}
