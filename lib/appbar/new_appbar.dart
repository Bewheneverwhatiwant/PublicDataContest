import 'package:flutter/material.dart';

class CustomNewAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomNewAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(title, style: const TextStyle(color: Colors.black)),
      shadowColor: Colors.grey.withOpacity(0.5),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
