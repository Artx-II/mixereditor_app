import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: Text(
              "Loading...",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600
              ),
            ),
          )
        ],
      ),
    );
  }
}