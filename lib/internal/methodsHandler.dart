import 'dart:io';

import 'package:flutter/services.dart';

enum MountType { mount, unmount }

class MethodsHandler {

  static const platform = const MethodChannel("mixerChannel");

  static Future<bool> getRoot() async {
    String result = await platform.invokeMethod('getRoot');
    if (result == "Permission Denied" || result == "Denied") {
      return false;
    } else {
      return true;
    }
  }
  
  static Future<String> executeCommand(String command) async {
    return await platform.invokeMethod('executeCommand', {"command": command});
  }

  static Future<String> mountPartition(MountType type, String partition) async {
    String result;
    if (type == MountType.mount) {
      result = await platform.invokeMethod('mountFs', {"mountPartition": partition});
    } else {
      result = await platform.invokeMethod('unmountFs', {"mountPartition": partition});
    }
    return result;
  }
}