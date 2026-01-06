import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class EmptyLocation extends StatelessWidget {
  const EmptyLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -Get.height / 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 32,
        children: [
          Image.asset("assets/images/arrow-dashed.png", height: Get.height / 3),
          Center(
            child: SizedBox(
              width: 180,
              child: Text(
                "Zoek of deel je locatie om het weer te zien",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
