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

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    setState(() {
      isMento = role == 'mentor';
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
                label: '전체 보기',
                onPressed: () {
                  Navigator.pushNamed(context, '/all');
                },
              ),
              GridButton(
                imagePath: null,
                label: 'IT',
                onPressed: () {
                  Navigator.pushNamed(context, '/it');
                },
              ),
              GridButton(
                imagePath: null,
                label: '언어',
                onPressed: () {
                  Navigator.pushNamed(context, '/language');
                },
              ),
              GridButton(
                imagePath: null,
                label: '디자인',
                onPressed: () {
                  Navigator.pushNamed(context, '/design');
                },
              ),
              GridButton(
                imagePath: null,
                label: '회계',
                onPressed: () {
                  Navigator.pushNamed(context, '/money');
                },
              ),
              GridButton(
                imagePath: null,
                label: '미용',
                onPressed: () {
                  Navigator.pushNamed(context, '/beauty');
                },
              ),
              GridButton(
                imagePath: null,
                label: '음악',
                onPressed: () {
                  Navigator.pushNamed(context, '/music');
                },
              ),
              GridButton(
                imagePath: null,
                label: '사진',
                onPressed: () {
                  Navigator.pushNamed(context, '/photo');
                },
              ),
              GridButton(
                imagePath: null,
                label: '기획',
                onPressed: () {
                  Navigator.pushNamed(context, '/thinking');
                },
              ),
              GridButton(
                imagePath: null,
                label: '기타',
                onPressed: () {
                  Navigator.pushNamed(context, '/other');
                },
              ),
            ],
          ),
        ),
        if (isMento) // isMento가 true면 멘토링 개설 버튼 보임
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
