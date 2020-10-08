import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mixereditor/internal/methodsHandler.dart';
import 'package:mixereditor/models/mixerConfig.dart';
import 'package:mixereditor/models/mixerValues.dart';
import 'package:mixereditor/ui/pages/homePage.dart';
import 'package:mixereditor/ui/pages/loadingPage.dart';
import 'package:mixereditor/ui/pages/noDevicePage.dart';
import 'package:mixereditor/ui/pages/rootDeniedPage.dart';
import 'package:path_provider/path_provider.dart';

enum DeviceStatus { Loading, Ready, RootDenied, NotFound }

class HomeScreen extends StatefulWidget {
  final AndroidDeviceInfo deviceInfo;
  HomeScreen({
    @required this.deviceInfo
  });
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // This device Mixer Config
  MixerConfig mixer;
  // Mixer Values from this Device
  MixerValues mixerValues;

  // Loading State
  DeviceStatus deviceStatus;

  // Mixer Lines
  List<String> listStrings;

  @override
  void initState() {
    deviceStatus = DeviceStatus.Loading;
    super.initState();
    initDevice();
  }

  void initDevice() async {
    var data;
    try {
      data = await rootBundle
        .loadString("devices/${widget.deviceInfo.device}.json");
    } catch (_) {}
    if (data != null) {
      var json = jsonDecode(data);
      mixer = MixerConfig.fromMap(json);
      // Ask for Root
      bool result = await MethodsHandler.getRoot();
      if (result == true) {
        File cachedMixerPathsFile = File("${(await getTemporaryDirectory()).path}/mixer.xml");
        await MethodsHandler.executeCommand("cp ${mixer.filePath} ${(await getTemporaryDirectory()).path}/mixer.xml");
        List<String> lines = await cachedMixerPathsFile.readAsLines();
        listStrings = lines;
        mixerValues = MixerValues(
          speakerGain: mixer.speakerLine == null
            ? null
            : getGainValue(lines, mixer.speakerLine),
          earpieceGain: mixer.earpieceLine == null
            ? null
            : getGainValue(lines, mixer.earpieceLine),
          headphoneGain: mixer.headphoneLines == null
            ? null
            : getGainValue(lines, mixer.headphoneLines.first),
          micBottomGain: mixer.micBottomLine == null
            ? null
            : getGainValue(lines, mixer.micBottomLine),
          micTopGain: mixer.micTopLine == null
            ? null
            : getGainValue(lines, mixer.micTopLine)
        );
        setState(() =>
          deviceStatus = DeviceStatus.Ready);
      } else {
        setState(() =>
          deviceStatus = DeviceStatus.RootDenied);
      }
    } else {
      setState(() =>
        deviceStatus = DeviceStatus.NotFound);
    }
  }

  int getGainValue(List<String> lines, int index) {
    String line = lines[index];
    return int.parse(line.split("=").last.replaceAll(new RegExp(r'[^0-9]'),''));
  }

  @override
  Widget build(BuildContext context) {
    Brightness _systemBrightness = Theme.of(context).brightness;
    Brightness _statusBarBrightness = _systemBrightness == Brightness.light
      ? Brightness.dark
      : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: _statusBarBrightness,
        statusBarIconBrightness: _statusBarBrightness,
        systemNavigationBarColor: Theme.of(context).cardColor,
        systemNavigationBarIconBrightness: _statusBarBrightness,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        shadowColor: Colors.green.withOpacity(0.1),
        title: Text(
          "Mixer Editor",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1.color
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 16,
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: homeWidget()
      )
    );
  }

  Widget homeWidget() {
    if (deviceStatus == DeviceStatus.Ready) {
      return HomePage(
        mixer: mixer,
        mixerValues: mixerValues,
        listString: listStrings,
      );
    } else if (deviceStatus == DeviceStatus.Loading) {
      return LoadingPage();
    } else if (deviceStatus == DeviceStatus.RootDenied) {
      return RootDeniedPage();
    } else {
      return NoDevicePage();
    }
  }
}