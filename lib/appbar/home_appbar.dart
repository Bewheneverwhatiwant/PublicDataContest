import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String logoPath;
  final double logoWidth;
  final double logoHeight;

  const HomeAppBar({
    super.key,
    required this.logoPath,
    required this.logoWidth,
    required this.logoHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0), // 로고 위치
        child: Image.asset(
          logoPath,
          width: logoWidth,
          height: logoHeight,
        ), // 로고 이미지
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
