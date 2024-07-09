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
    _checkRole();
    _checkLoginStatus();
  }

  Future<void> _checkRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    setState(() {
      isMento = role == 'mentor';
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getString('accessToken') != null;
    });
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
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            children: <Widget>[
              GridButton(
                imagePath: null,
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
                imagePath: null,
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
                imagePath: null,
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
                imagePath: null,
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
                imagePath: null,
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
                imagePath: null,
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
                imagePath: null,
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
                imagePath: null,
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
                imagePath: null,
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
                imagePath: null,
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
            ],
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
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/makementoring');
                },
                child: const Text('멘토링 개설하기'),
              ),
            ),
          ),
      ],
    );
  }
}
