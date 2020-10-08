import 'package:flutter/material.dart';
import 'package:mixereditor/ui/animations/showUp.dart';

class RootDeniedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShowUpTransition(
        duration: Duration(milliseconds: 800),
        delay: Duration(milliseconds: 300),
        slideSide: SlideFromSlide.BOTTOM,
        forward: true,
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.1),
                offset: Offset(8,8),
                blurRadius: 16
              )
            ]
          ),
          child: Text(
            "Root Denied",
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
    );
  }
}