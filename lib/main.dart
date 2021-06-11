import 'package:flutter/material.dart';
import 'package:fimber/fimber.dart';

import 'pages/calibration.dart';
import 'pages/control.dart';

import 'ble/ble-engine.dart';
import 'ble/device-state.dart';
import 'ble/mock-ble-engine.dart';

void main() {
  Fimber.plantTree(DebugTree());
  runApp(Gulldroid());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();



class Gulldroid extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<Gulldroid> {

  AppRouterDelegate _routerDelegate = AppRouterDelegate();
  AppRouteInformationParser _routeInformationParser =
  AppRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GULLdroid',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black54,
        dialogBackgroundColor: Colors.black12,
        scaffoldBackgroundColor: Colors.black54,
        primarySwatch: Colors.indigo,
        accentColor: Colors.deepPurpleAccent,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.indigo,
              minimumSize: Size.fromHeight(50)
          ),
        ),
      ),
    );
  }
}



class AppRoutePath {
  final bool isUnknown;
  final bool isCalibration;

  AppRoutePath.home()
      : isUnknown = false,
        isCalibration = false;

  AppRoutePath.calibration()
      : isUnknown = false,
        isCalibration = true;

  AppRoutePath.unknown()
      : isUnknown = true,
        isCalibration = false;

  bool get isHomePage =>
      !isCalibration && !isUnknown;

  bool get isCalibrationPage =>
      isCalibration;
}



class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {

  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return AppRoutePath.home();
    }

    // Handle '/calibration'
    if (uri.pathSegments[0] == 'calibration') {
      return AppRoutePath.calibration();
    }

    // Handle unknown routes
    return AppRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isCalibration) {
      return RouteInformation(location: '/calibration');
    }
    return null;
  }

}



class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, WidgetsBindingObserver, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  final String title;
  final BleEngine ble = MockBleEngine();

  DeviceState _deviceState = DeviceState.unavailable;
  bool _show404 = false;
  bool _calibrated = false;

  AppRouterDelegate()
      : title = 'GULLdroid',
        navigatorKey = GlobalKey<NavigatorState>() {
    initState();
  }

  AppRoutePath get currentConfiguration {
    if (_show404) {
      return AppRoutePath.unknown();
    }
    return _calibrated
        ? AppRoutePath.home()
        : AppRoutePath.calibration();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey('AppPage'),
          child: Scaffold(
            appBar: AppBar(
              leading: Icon(getBluetoothIcon(),
                color: getBluetoothColor()
              ),
              title: Text(title)
            ),
            body: (_show404)
              ? UnknownScreen()
              : (!_calibrated)
                  ? CalibrationPage(_handleOnAccept)
                  : ControlPage()
          ),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath path) async {
    if (path.isUnknown) {
      _show404 = true;
      return;
    }

    _show404 = false;
  }

  //@override
  void initState() {
    //super.initState();
    WidgetsBinding.instance.addObserver(this);
    ble.onDeviceStateChange().listen((deviceState) {
//          setState(() {
            Fimber.d('Device state: $deviceState');
            _deviceState = deviceState;
  //        });
        }
    );
    ble.init();
  }

  @override
  void dispose() async {
    ble.dispose();
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
          ble.disconnect();
          break;
        }
      case AppLifecycleState.paused:
        {
          Fimber.d('App Paused');
          ble.disconnect();
          break;
        }
      case AppLifecycleState.resumed:
        {
          Fimber.d('App Resumed');
          ble.connect();
          break;
        }
    }
    super.didChangeAppLifecycleState(state);
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


  void _handleOnAccept() {
    _calibrated = true;
    notifyListeners();
  }
}


class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('404!'),
      ),
    );
  }
}
