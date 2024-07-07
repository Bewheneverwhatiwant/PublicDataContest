import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getString('accessToken') != null;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    setState(() {
      _isLoggedIn = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          widget.logoPath,
          width: widget.logoWidth,
          height: widget.logoHeight,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: TextButton(
            onPressed: _isLoggedIn
                ? _logout
                : () {
                    Navigator.pushNamed(context, '/login');
                  },
            style: TextButton.styleFrom(
              side: const BorderSide(color: Colors.grey, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              _isLoggedIn ? '로그아웃' : '로그인',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
