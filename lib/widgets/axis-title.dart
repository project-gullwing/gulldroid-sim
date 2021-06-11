import 'package:flutter/material.dart';

class AxisTitle extends StatelessWidget {

  AxisTitle(this._axis);

  final Axis _axis;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon((_axis == Axis.horizontal) ? Icons.panorama_horizontal : Icons.panorama_vertical),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
            child: Text((_axis == Axis.horizontal) ? 'AZI' : 'ALT'),
          ),
        ],
      ),
    );
  }
}