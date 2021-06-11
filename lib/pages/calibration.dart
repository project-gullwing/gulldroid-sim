import 'package:flutter/material.dart';
import 'package:fimber/fimber.dart';
import 'package:gulldroid_sim/widgets/axis-title.dart';

class CalibrationPage extends StatefulWidget {
  final VoidCallback onAccept;

  CalibrationPage(
      this.onAccept,
  ) : super();

  @override
  _CalibrationPageState createState()=> _CalibrationPageState();
}


class _CalibrationPageState extends State<CalibrationPage> {

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      Fimber.d('Hovno $_counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AxisTitle(Axis.vertical),
                      Text("XX° XX'' XX.XXX'"),
                    ]
                ),
              ),
              // + Angle buttons
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
                            child: TextButton.icon(
                                onPressed: _incrementCounter,
                                icon: Icon(Icons.keyboard_arrow_up),
                                label: Text('1°')
                            ),
                          )
                      ),
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                            child: TextButton.icon(
                                onPressed: _incrementCounter,
                                icon: Icon(Icons.keyboard_arrow_up),
                                label: Text('0.1°')
                            ),
                          )
                      ),
                    ]),
              ),

              // - Angle buttons
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
                            child: TextButton.icon(
                                onPressed: _incrementCounter,
                                icon: Icon(Icons.keyboard_arrow_down),
                                label: Text('1°')
                            ),
                          )
                      ),
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                            child: TextButton.icon(
                                onPressed: _incrementCounter,
                                icon: Icon(Icons.keyboard_arrow_down),
                                label: Text('0.1°')
                            ),
                          )
                      ),
                    ]),
              ),
              // - Set level button
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: _incrementCounter,
                          icon: Icon(Icons.horizontal_rule),
                          label: Text('Mark horizontal'),
                          style: TextButton.styleFrom(backgroundColor: Theme.of(context).accentColor),
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 28, 0, 7),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AxisTitle(Axis.horizontal),
                      Text("XX° XX'' XX.XXX'"),
                    ]
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: _incrementCounter,
                          icon: Icon(Icons.explore),
                          label: Text('From compass'),
                          style: TextButton.styleFrom(backgroundColor: Theme.of(context).accentColor),
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: _incrementCounter,
                          icon: Icon(Icons.south),
                          label: Text('Mark south'),
                          style: TextButton.styleFrom(backgroundColor: Theme.of(context).accentColor),
                        ),
                      ),
                    ]),
              ),
              Expanded(
                  child: Container()
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: widget.onAccept,
                            child: Text('Accept')
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      );
  }
}