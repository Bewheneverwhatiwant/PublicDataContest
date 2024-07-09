// gridbutton.dart

import 'package:flutter/material.dart';

class GridButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int kind;
  final VoidCallback onPressed;

  const GridButton({
    required this.icon,
    required this.label,
    required this.kind,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.all(5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
