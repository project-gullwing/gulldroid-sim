import 'dart:async';

import 'device-state.dart';

class BleEngine {

  Stream<DeviceState> onDeviceStateChange() {return null;}

  Stream<String> onDeviceData() {return null;}
  
  init() {}

  connect() {}

  send(String data) {}

  disconnect() {}
  
  dispose() {}
}