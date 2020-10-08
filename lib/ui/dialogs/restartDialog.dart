import 'package:flutter/material.dart';

class RestartDialog extends StatelessWidget {
  final Function onSkip;
  final Function onRestart;
  RestartDialog({
    @required this.onRestart,
    @required this.onSkip
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      title: Text("Success"),
      content: Text("Restart is now needed to apply new changes, restart now?"),
      actions: [
        FlatButton(
          child: Text(
            "Restart",
            style: TextStyle(
              color: Colors.green
            ),
          ),
          onPressed: onRestart,
        ),
        FlatButton(
          child: Text(
            "Skip",
            style: TextStyle(
              color: Colors.green
            ),
          ),
          onPressed: onSkip
        )
      ],
    );
  }

}