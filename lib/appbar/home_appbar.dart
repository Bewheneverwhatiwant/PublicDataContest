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
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          logoPath,
          width: logoWidth,
          height: logoHeight,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          style: TextButton.styleFrom(
            side: const BorderSide(color: Colors.grey, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            '로그인',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
