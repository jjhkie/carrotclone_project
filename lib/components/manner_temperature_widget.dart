import 'package:flutter/material.dart';

class MannerTemperature extends StatelessWidget {
  double mannerTemp;
  late int level;
  final List<Color> temperColors = [
    Color(0xff072038),
    Color(0xff0d3a65),
    Color(0xff186ec0),
    Color(0xff37b24d),
    Color(0xffffad13),
    Color(0xfff76707),
  ];

  MannerTemperature({Key? key, required this.mannerTemp}) {
    _calcTempLevel();
  }

  void _calcTempLevel() {
    if (mannerTemp <= 20) {
      level = 0;
    } else if (mannerTemp > 20 && mannerTemp <= 32) {
      level = 1;
    } else if (mannerTemp > 32 && mannerTemp <= 36.5) {
      level = 2;
    } else if (mannerTemp > 36.5 && mannerTemp <= 40) {
      level = 3;
    } else if (mannerTemp > 40 && mannerTemp <= 50) {
      level = 4;
    } else if (mannerTemp > 50) {
      level = 5;
    }
  }

  Widget _makeTempLabelAndBar() {
    return Container(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${mannerTemp}°C",
            style: TextStyle(
                color: temperColors[level],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),

          ClipRRect(
            borderRadius:BorderRadius.circular(10),
            child: Container(
              height: 6,
              color: Colors.black.withOpacity(0.2),
              child: Row(
                children: [
                  Container(height: 6,width:60/99 * mannerTemp,color:temperColors[level])
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_makeTempLabelAndBar(),
            Container(margin: const EdgeInsets.only(left:7),width:30,height: 30,child:Image.asset("assets/images/level-${level}.jpg"),)],
          ),
          Text("매너온도",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 12,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }
}
