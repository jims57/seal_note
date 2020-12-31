import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

enum DeviceNameType { Web, iPhone, iPad, Android, Windows, MacOS, Unknown }

class DeviceHandler {
  static DeviceNameType getDeviceNameType() {
    DeviceNameType deviceNameType;

    if (kIsWeb) {
      deviceNameType = DeviceNameType.Web;
    } else {
      if (Platform.isIOS) {
        if (Device.get().isTablet) {
          deviceNameType = DeviceNameType.iPad;
        } else {
          deviceNameType = DeviceNameType.iPhone;
        }
      } else if (Platform.isAndroid) {
        deviceNameType = DeviceNameType.Android;
      } else if (Platform.isWindows) {
        deviceNameType = DeviceNameType.Windows;
      } else if (Platform.isMacOS) {
        deviceNameType = DeviceNameType.MacOS;
      } else {
        deviceNameType = DeviceNameType.Unknown;
      }
    }

    return deviceNameType;
  }
}
