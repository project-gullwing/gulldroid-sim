// import 'package:fimber/fimber.dart';
// import 'package:flutter_ble_lib/flutter_ble_lib.dart';
// import 'package:gulldroid/ble/uuids.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class Ble {
//   BleManager bleManager = BleManager();
//   Peripheral peripheral;
//
//   init() async {
//     if (await Permission.locationWhenInUse.request().isGranted) {
//       Fimber.d('Location permission granted');
//       await bleManager.createClient();
//       Fimber.d('BLE Client initialized');
//       bleManager.startPeripheralScan(
//         scanMode: ScanMode.lowLatency,
//         callbackType: CallbackType.allMatches,
//         uuids: [
// //          Uuids.gullwingService,
//         ],
//       ).listen((scanResult) {
//         Fimber.d("Scanned Peripheral: ${scanResult.peripheral.name} ... RSSI ${scanResult.rssi} dB");
//         Fimber.d("Advertised services: ${scanResult.advertisementData.serviceUuids}");
//         peripheral = scanResult.peripheral;
//         //connect();
//         //bleManager.stopPeripheralScan();
//       });
//     }
//   }
//
//   dispose() {
//     bleManager.destroyClient();
//     Fimber.d('BLE Client disposed');
//   }
//
//   connect() {
//     if (peripheral != null) {
//       Fimber.d('BLE Connect');
//     } else {
//       Fimber.d('BLE No Connection');
//     }
//   }
//
//   disconnect () {
//     Fimber.d('BLE Disconnect');
//   }
// }