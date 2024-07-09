import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gridbutton.dart';

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  _ButtonsState createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  bool isMento = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loginStatus = prefs.getString('accessToken') != null;
    if (mounted) {
      setState(() {
        isLoggedIn = loginStatus;
      });
    }
    if (loginStatus) {
      _checkRole();
    }
  }

  Future<void> _checkRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    if (mounted) {
      setState(() {
        isMento = role == 'mentor';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            children: <Widget>[
              GridButton(
                icon: Icons.category,
                label: '전체',
                kind: 1,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/categorytemplate',
                    arguments: {'kind': 1},
                  );
                },
              ),
              GridButton(
                icon: Icons.language,
                label: '언어',
                kind: 2,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/categorytemplate',
                    arguments: {'kind': 2},
                  );
                },
              ),
              GridButton(
                icon: Icons.account_balance_wallet,
                label: '회계',
                kind: 3,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/categorytemplate',
                    arguments: {'kind': 3},
                  );
                },
              ),
              GridButton(
                icon: Icons.computer,
                label: 'IT',
                kind: 4,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/categorytemplate',
                    arguments: {'kind': 4},
                  );
                },
              ),
              GridButton(
                icon: Icons.design_services,
                label: '디자인',
                kind: 5,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/categorytemplate',
                    arguments: {'kind': 5},
                  );
                },
              ),
              GridButton(
                icon: Icons.music_note,
                label: '음악',
                kind: 6,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/categorytemplate',
                    arguments: {'kind': 6},
                  );
                },
              ),
              GridButton(
                icon: Icons.spa,
                label: '미용',
                kind: 7,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/categorytemplate',
                    arguments: {'kind': 7},
                  );
                },
              ),
              GridButton(
                icon: Icons.camera_alt,
                label: '사진',
                kind: 8,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/categorytemplate',
                    arguments: {'kind': 8},
                  );
                },
              ),
              GridButton(
                icon: Icons.lightbulb,
                label: '기획',
                kind: 9,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/categorytemplate',
                    arguments: {'kind': 9},
                  );
                },
              ),
              GridButton(
                icon: Icons.palette,
                label: '공예',
                kind: 10,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/categorytemplate',
                    arguments: {'kind': 10},
                  );
                },
              ),
            ].map((button) {
              return Container(
                color: Colors.white,
                child: button,
              );
            }).toList(),
          ),
        ),
        if (isLoggedIn && isMento) // 사용자가 로그인하고 멘토일 때만 멘토링 개설 버튼 보임
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F79F7),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/makementoring');
                },
                child: const Text(
                  '멘토링 개설하기',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
