import 'package:flutter_is_emulator/flutter_is_emulator.dart';

class SimulatorHandler {
  static Future<bool> isSimulatorOrEmulator() async {
    bool isSimulator = await FlutterIsEmulator.isDeviceAnEmulatorOrASimulator;

    return isSimulator;
  }
}
