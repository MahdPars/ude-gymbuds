import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final int value;
  final VoidCallback onTap;
  const Tile({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        '$value',
        style: TextStyle(
            fontSize: 80, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
