import 'package:flutter/material.dart';
import 'package:fimber/fimber.dart';

class ControlPage extends StatefulWidget {
  ControlPage() : super();

  @override
  _ControlPageState createState()=> _ControlPageState();
}


class _ControlPageState extends State<ControlPage> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          //onPressed: widget.onCalibration(),
          child: Text('Calibration')
      ),
    );
  }

}
