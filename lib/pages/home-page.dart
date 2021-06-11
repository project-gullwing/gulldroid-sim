import 'package:flutter/material.dart';
import 'package:fimber/fimber.dart';
import 'package:gulldroid_sim/ble/ble-engine.dart';
import 'package:gulldroid_sim/ble/device-state.dart';
import 'package:gulldroid_sim/ble/mock-ble-engine.dart';

class HomePage extends StatefulWidget {
  final String title;
  final BleEngine ble = MockBleEngine();

  HomePage({Key key, this.title})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  DeviceState _deviceState = DeviceState.unavailable;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.ble.onDeviceStateChange().listen(
        (deviceState) {
          setState(() {
            Fimber.d('Device state: $deviceState');
            _deviceState = deviceState;
          });
        }
    );
    widget.ble.init();
  }

  @override
  void dispose() async {
    widget.ble.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
        {
          Fimber.d('App detached');
          break;
        }
      case AppLifecycleState.inactive:
        {
          Fimber.d('App Inactive');
          widget.ble.disconnect();
          break;
        }
      case AppLifecycleState.paused:
        {
          Fimber.d('App Paused');
          widget.ble.disconnect();
          break;
        }
      case AppLifecycleState.resumed:
        {
          Fimber.d('App Resumed');
          widget.ble.connect();
          break;
        }
    }
    super.didChangeAppLifecycleState(state);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(getBluetoothIcon(),
          color: getBluetoothColor()
        ),
        title: Text(widget.title)
      ),
      body: Container()
    );
  }

  IconData getBluetoothIcon() {
    switch (_deviceState) {
      case DeviceState.connected:
        return Icons.bluetooth_connected;

      case DeviceState.connecting:
      case DeviceState.disconnecting:
        return Icons.bluetooth_searching;

      default:
        return Icons.bluetooth_disabled;
    }
  }

  Color getBluetoothColor() {
    switch (_deviceState) {
      case DeviceState.connected:
        return Colors.deepPurpleAccent;

      case DeviceState.scanning:
      case DeviceState.connecting:
        return Colors.lightBlueAccent;

      case DeviceState.disconnecting:
        return Colors.amber;

      default:
        return Colors.white70;
    }
  }
}



