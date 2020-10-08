import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mixereditor/internal/methodsHandler.dart';
import 'package:mixereditor/models/mixerConfig.dart';
import 'package:mixereditor/models/mixerValues.dart';
import 'package:mixereditor/ui/dialogs/mountErrorDialog.dart';
import 'package:mixereditor/ui/dialogs/restartDialog.dart';
import 'package:mixereditor/ui/widgets/mediaSlider.dart';

class HomePage extends StatefulWidget {
  final MixerConfig mixer;
  final MixerValues mixerValues;
  final List<String> listString;
  HomePage({
    @required this.mixer,
    @required this.mixerValues,
    @required this.listString
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Current MixerValues
  MixerValues mixerValues;

  // Current MixerPaths
  List<String> mixerListStrings;

  @override
  void initState() {
    mixerValues = widget.mixerValues;
    mixerListStrings = widget.listString;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Row(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Device: ",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          )
                        ),
                        TextSpan(
                          text: widget.mixer.device,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          )
                        ),
                      ]
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.cached, size: 18),
                    color: Theme.of(context).iconTheme.color,
                    onPressed: () async {
                      // Get Current Speaker Gain
                      if (widget.mixer.speakerLine != null) {
                        mixerValues.speakerGain = await getCurrentValue(
                          widget.mixer.speakerLine
                        );
                      }
                      // Get Current Earpiece Gain
                      if (widget.mixer.earpieceLine != null) {
                        mixerValues.earpieceGain = await getCurrentValue(
                          widget.mixer.earpieceLine
                        );
                      }
                      // Get Current Headphones Gain
                      if (widget.mixer.headphoneLines != null) {
                        mixerValues.headphoneGain = await getCurrentValue(
                          widget.mixer.headphoneLines[0]
                        );
                      }
                      // Get Current Bottom Mic Gain
                      if (widget.mixer.micBottomLine != null) {
                        mixerValues.micBottomGain = await getCurrentValue(
                          widget.mixer.micBottomLine
                        );
                      }
                      // Get Current Top Mic Gain
                      if (widget.mixer.micTopLine != null) {
                        mixerValues.micTopGain = await getCurrentValue(
                          widget.mixer.micTopLine
                        );
                      }
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  // Speaker
                  if (widget.mixer.speakerLine != null)
                  MediaSlider(
                    value: mixerValues.speakerGain,
                    min: 0,
                    max: 100,
                    mediaIcon: Icon(Icons.speaker),
                    mediaTitle: "Speaker Gain",
                    onChanged: (int gainValue) {
                      setState(() => mixerValues.speakerGain = gainValue);
                    },
                  ),
                  // Earpiece
                  if (widget.mixer.earpieceLine != null)
                  MediaSlider(
                    value: mixerValues.earpieceGain,
                    min: 0,
                    max: 100,
                    mediaIcon: Icon(Icons.speaker_phone),
                    mediaTitle: "Earpiece Gain",
                    onChanged: (int gainValue) {
                      setState(() => mixerValues.earpieceGain = gainValue);
                    },
                  ),
                  // Headphones
                  if (widget.mixer.headphoneLines != null)
                  MediaSlider(
                    value: mixerValues.headphoneGain,
                    min: 0,
                    max: 100,
                    mediaIcon: Icon(Icons.headset),
                    mediaTitle: "Headphone Gain (L/R)",
                    onChanged: (int gainValue) {
                      setState(() => mixerValues.headphoneGain = gainValue);
                    },
                  ),
                  // Bottom Mic
                  if (widget.mixer.micBottomLine != null)
                  MediaSlider(
                    value: mixerValues.micBottomGain,
                    min: 0,
                    max: 100,
                    mediaIcon: Icon(Icons.mic),
                    mediaTitle: "Mic Gain (Bottom)",
                    onChanged: (int gainValue) {
                      setState(() => mixerValues.micBottomGain = gainValue);
                    },
                  ),
                  // Top Mic
                  if (widget.mixer.micTopLine != null)
                  MediaSlider(
                    value: mixerValues.micTopGain,
                    min: 0,
                    max: 100,
                    mediaIcon: Icon(Icons.mic),
                    mediaTitle: "Mic Gain (Top)",
                    onChanged: (int gainValue) {
                      setState(() => mixerValues.micTopGain = gainValue);
                    },
                  )
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save, color: Colors.white),
          backgroundColor: Colors.green,
          onPressed: () async {
            // Apply changes only to Modified Gain Devices
            //
            // Mount Partition
            String mountResult = await MethodsHandler.mountPartition(MountType.mount, widget.mixer.mountPartition);
            if (mountResult != "OK") {
              showDialog(context: context, builder: (context)
                => MountErrorDialog(filesystem: widget.mixer.mountPartition));
              return;
            }
            // Apply changes to Speaker
            if (widget.mixer.speakerLine != null) {
            int oldValue = await getCurrentValue(widget.mixer.speakerLine);
              if (mixerValues.speakerGain != oldValue) {
                applyMixerModification(
                  widget.mixer.speakerLine,
                  mixerValues.speakerGain
                );
              }
            }
            // Apply changes to Earpiece
            if (widget.mixer.earpieceLine != null) {
              int oldValue = await getCurrentValue(widget.mixer.earpieceLine);
              if (mixerValues.earpieceGain != oldValue) {
                await applyMixerModification(
                  widget.mixer.earpieceLine,
                  mixerValues.earpieceGain
                );
              }
            }
            // Apply changes to Headphones
            if (widget.mixer.headphoneLines != null) {
              int oldValue = await getCurrentValue(widget.mixer.headphoneLines[0]);
              if (mixerValues.headphoneGain != oldValue) {
                await applyMixerModification(
                  widget.mixer.headphoneLines[0],
                  mixerValues.headphoneGain
                );
                await applyMixerModification(
                  widget.mixer.headphoneLines[1],
                  mixerValues.headphoneGain
                );
              }
            }
            // Apply changes to Bottom Mic
            if (widget.mixer.micBottomLine != null) {
              int oldValue = await getCurrentValue(widget.mixer.micBottomLine);
              if (mixerValues.micBottomGain != oldValue) {
                applyMixerModification(
                  widget.mixer.micBottomLine,
                  mixerValues.micBottomGain
                );
              }
            }
            // Apply changes to Top Mic
            if (widget.mixer.micTopLine != null) {
              int oldValue = await getCurrentValue(widget.mixer.micTopLine);
              if (mixerValues.micTopGain != oldValue) {
                applyMixerModification(
                  widget.mixer.micTopLine,
                  mixerValues.micTopGain
                );
              }
            }
            // Unmount Partition
            await MethodsHandler.mountPartition(MountType.unmount, widget.mixer.mountPartition);
            // Show Restart Dialog
            showDialog(
              context: context,
              builder: (context) {
                return RestartDialog(
                  onRestart: () {
                    MethodsHandler.executeCommand("su -c reboot").then((value) => print(value));
                  },
                  onSkip: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<String> applyMixerModification(int line, int newValue) async {
    String oldValue = mixerListStrings[line-1].split("=").last.replaceAll(new RegExp(r'[^0-9]'),'');
    String replacementString = "${line}s/$oldValue/$newValue/";
    mixerListStrings[line-1] = mixerListStrings[line-1].replaceAll('$oldValue', '$newValue');
    return await MethodsHandler.executeCommand(
      "su -c sed -i \"$replacementString\" ${widget.mixer.filePath}"
    );
  }

  Future<int> getCurrentValue(int line) async {
    String readLine = mixerListStrings[line];
    return int.parse(readLine.split("=").last.replaceAll(new RegExp(r'[^0-9]'),''));
  }
}