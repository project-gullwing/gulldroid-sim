import 'dart:async';
import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:gulldroid_sim/ble/device-state.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'ble-engine.dart';

class MockBleEngine
    implements BleEngine {

  IO.Socket _socket;
  StreamController<DeviceState> _deviceState$ = new StreamController.broadcast();
  StreamController<String> _deviceData$ = new StreamController.broadcast();

  MockBleEngine() {
    _updateDeviceState(DeviceState.unavailable);
  }


  @override
  Stream<DeviceState> onDeviceStateChange() {
    return _deviceState$.stream;
  }


  @override
  Stream<String> onDeviceData() {
    return _deviceData$.stream;
  }


  @override
  init() async {
    connect();
  }


  @override
  connect() {
    _socket = IO.io('http://localhost:3000',
        OptionBuilder()
            .setTransports(['websocket'])
            .build());

    _socket.onConnecting((_) => {
      Fimber.d('BLE: Connecting'),
      _updateDeviceState(DeviceState.connecting)
    });

    _socket.onConnect((_) {
      Fimber.d('BLE: Connected');
      _socket.emit('cmd', 'test');
      _updateDeviceState(DeviceState.connected);
    });

    _socket.on('status', (data) => {
      //Fimber.d('BLE: Status: $data'),
      _handleDataFromDevice(data)
    });

    _socket.onError((error) => {
      Fimber.d('BLE: Error: $error'),
      _updateDeviceState(DeviceState.unavailable)
    });

    _socket.onDisconnect((_) => {
      Fimber.d('BLE: Disconnected'),
      _updateDeviceState(DeviceState.unavailable)
    });

    _socket.on('fromServer', (_) => print(_));
  }


  @override
  send(String data) async {
    _socket.emit('cmd', data);
  }


  @override
  disconnect() async {
    _updateDeviceState(DeviceState.disconnecting);
    _socket.disconnect();
  }


  @override
  dispose() {
    disconnect();
    _socket.close();
    _deviceState$.close();
    _deviceData$.close();
  }


  void _updateDeviceState(DeviceState deviceState) {
    //Fimber.d('[BLE] Device state change: $deviceState');
    _deviceState$.add(deviceState);
  }


  void _handleDataFromDevice(String value) {
    try {
      //Fimber.d('TxChar: $t');
      _deviceData$.add(value);
    } catch (e) {
      Fimber.e('[BLE] Received data handling error: $e');
    }
  }

}