import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:mixereditor/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
  runApp(MixerEditor(
    deviceInfo: deviceInfo,
  ));
}

class MixerEditor extends StatelessWidget {
  final AndroidDeviceInfo deviceInfo;
  MixerEditor({
    @required this.deviceInfo,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MixerEditor",
      home: HomeScreen(
        deviceInfo: deviceInfo,
      ),
    );
  }
}