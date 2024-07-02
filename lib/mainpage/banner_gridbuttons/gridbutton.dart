import 'package:flutter/material.dart';

class GridButton extends StatelessWidget {
  final String? imagePath;
  final String label;
  final VoidCallback onPressed;

  const GridButton({
    super.key,
    this.imagePath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 40, // 가로 길이
          height: 40, // 세로 길이
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(0),
            ),
            onPressed: onPressed,
            child: Ink(
              decoration: BoxDecoration(
                color: imagePath == null ? Colors.grey : null,
                image: imagePath != null
                    ? DecorationImage(
                        image: AssetImage(imagePath!),
                        fit: BoxFit.cover,
                      )
                    : null,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
