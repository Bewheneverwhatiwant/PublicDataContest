import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'new_appbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginEnabled = false;

  void _validateInputs() {
    setState(() {
      _isLoginEnabled = _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoginEnabled) {
      final url = '${dotenv.env['API_SERVER']}/api/auth/signin';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": _usernameController.text,
          "password": _passwordController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final accessToken = responseData['accessToken'];
        final role = responseData['role'];

        // 엑세스 토큰과 role을 shared_preferences에 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('role', role);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('로그인되었습니다!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/main', (route) => false);
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('로그인 실패'),
              content: const Text('아이디 또는 비밀번호가 잘못되었습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      appBar: const CustomNewAppBar(title: '로그인'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 25),
              Container(
                width: 300,
                child: TextField(
                  controller: _usernameController,
                  obscureText: true,
                  cursorColor: GlobalColors.mainColor,
                  decoration: InputDecoration(
                    hintText: '아이디를 입력해주세요.',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0), // 둥근 모서리 설정
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide(
                          color: GlobalColors.mainColor,
                          width: 2.0), // 클릭했을 때 border 색상 설정
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 300,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  cursorColor: GlobalColors.mainColor,
                  decoration: InputDecoration(
                    hintText: '비밀번호를 입력해주세요.',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0), // 둥근 모서리 설정
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide(
                          color: GlobalColors.mainColor,
                          width: 2.0), // 클릭했을 때 border 색상 설정
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoginEnabled ? _login : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoginEnabled
                        ? GlobalColors.mainColor
                        : GlobalColors.lightgray,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isLoginEnabled
                            ? GlobalColors.whiteColor
                            : GlobalColors.lightgray),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('항해가 처음이시라면'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                          color: GlobalColors.mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
