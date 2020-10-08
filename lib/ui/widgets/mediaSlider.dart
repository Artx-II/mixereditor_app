import 'package:flutter/material.dart';

class MediaSlider extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;
  final Widget mediaIcon;
  final String mediaTitle;
  MediaSlider({
    @required this.value,
    @required this.max,
    @required this.min,
    @required this.onChanged,
    @required this.mediaIcon,
    @required this.mediaTitle
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(Icons.headset, color: Colors.green),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                      children: [
                        TextSpan(
                          text: "$mediaTitle: "
                        ),
                        TextSpan(
                          text: "$value",
                          style: TextStyle(
                            color: Colors.green
                          )
                        )
                      ]
                    )
                  )
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16, right: 4),
                alignment: Alignment.center,
                child: Text(
                  "0"
                ),
              ),
              Expanded(
                child: Slider(
                  value: value.toDouble(),
                  min: 0,
                  max: 100,
                  activeColor: Colors.green,
                  inactiveColor: Colors.black12,
                  onChanged: (double value) {
                    onChanged(value.round());
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 4, right: 16),
                alignment: Alignment.center,
                child: Text(
                  "100"
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}