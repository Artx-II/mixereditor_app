import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MountErrorDialog extends StatelessWidget {
  final String filesystem;
  MountErrorDialog({
    this.filesystem
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      title: Text("Error Mounting Filesystem"),
      content: Text(
        "An error as ocurred while trying to mount ($filesystem)," +
        "please ensure you have BusyBox installed or get it from Google Play"
      ),
      actions: [
        FlatButton(
          child: Text("Get BusyBox", style: TextStyle(color: Colors.green)),
          onPressed: () {
            launch("https://play.google.com/store/apps/details?id=stericson.busybox");
          },
        )
      ],
    );
  }
}