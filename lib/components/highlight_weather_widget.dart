import 'package:flutter/material.dart';

class HighlightWeatherWidget extends StatelessWidget {
  const HighlightWeatherWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.valueAndType,
  });
  final String imagePath;
  final String title;
  final String valueAndType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Colors.white.withAlpha(100)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(220),
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(image: AssetImage(imagePath)),
                ),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              Text(
                valueAndType,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
