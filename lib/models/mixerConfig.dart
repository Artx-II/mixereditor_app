import 'package:flutter/material.dart';

/// Model used by the app to allow mixer_paths Modifications
/// to an specific device, "Line" means the specific line
/// where this app will read the ctl and modify its value.
/// 
/// [device] and [filePath] are required, the other variables
/// are optional, undefined variables will not show it's value
/// Slider in the app HomeScreen.
/// 
/// [headphoneLines] is a [List<int>] which should have two,
/// values, the value for right headphone and left headphone,
/// more than two is not allowed (why would it be)
class MixerConfig {

  String device;
  String mountPartition;
  String filePath;
  int speakerLine;
  int earpieceLine;
  List<int> headphoneLines;
  int micBottomLine;
  int micTopLine;

  MixerConfig({
    @required this.device,
    @required this.mountPartition,
    @required this.filePath,
    this.speakerLine,
    this.earpieceLine,
    this.headphoneLines,
    this.micBottomLine,
    this.micTopLine,
  });

  MixerConfig.fromMap(Map<String, dynamic> map) {
    device         = map["device"];
    mountPartition = map["mountPartition"];
    filePath       = map["filePath"];
    speakerLine    = map["speakerLine"];
    earpieceLine   = map["earpieceLine"];
    headphoneLines = ([
      map["headphoneLines"][0],
      map["headphoneLines"][1]
    ]);
    micBottomLine  = map["micBottomLine"];
    micTopLine     = map["micTopLine"];
  }
  
}