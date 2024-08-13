import 'package:flutter/material.dart';

class GradientIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const GradientIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // 아이콘 주위의 원 배경 색상
      ),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [
              Color(0xFF33CBAC),
              Color(0xFF1089E4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: IconButton(
          icon: Icon(icon),
          color: Colors.white, // 기본 아이콘 색상 (ShaderMask에 의해 덮어쓰기 됨)
          onPressed: onPressed,
        ),
      ),
    );
  }
}
