import 'package:flutter/material.dart';

class TourThumbnail extends StatelessWidget {
  const TourThumbnail({
    Key? key,
    required this.id,
    required this.label,
    this.length = 0,
    this.onTap,
  }) : super(key: key);

  final int id;
  final String label;
  final double length;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: () => onTap?.call(id),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(label)),
              Text('Länge: $length km'),
            ],
          ),
        ),
      ),
    );
  }
}
