import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
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
  String _errorMessage = '';

  void _validateInputs() {
    setState(() {
      _isLoginEnabled = _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
      _errorMessage = ''; // 입력 변경 시 오류 메시지 초기화
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

        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      } else {
        setState(() {
          _errorMessage = '아이디 또는 비밀번호가 잘못되었습니다.';
        });
      }
    }
  }

  Future<void> _showFindIdModal(BuildContext context) async {
    TextEditingController emailController = TextEditingController();
    bool isEmailValid = true;
    String? userId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('아이디 찾기'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (userId == null) ...[
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: '이메일을 입력하세요.',
                        hintStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        errorText: isEmailValid ? null : '유효한 이메일을 입력하세요.',
                      ),
                      onChanged: (value) {
                        setState(() {
                          isEmailValid =
                              RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
                        });
                      },
                    ),
                  ] else ...[
                    Text('고객님의 아이디는 $userId 입니다.'),
                  ],
                ],
              ),
              actions: [
                if (userId == null) ...[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: isEmailValid
                        ? () async {
                            final response =
                                await _findId(emailController.text);
                            if (response != null) {
                              setState(() {
                                userId = response;
                              });
                            }
                          }
                        : null,
                    child: const Text('찾기'),
                  ),
                ] else ...[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('닫기'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (userId != null) {
                        Clipboard.setData(ClipboardData(text: userId!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('아이디가 클립보드에 복사되었습니다.'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    child: const Text('복사하기'),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> _findId(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final url = '${dotenv.env['API_SERVER']}/api/auth/find_id?email=$email';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error decoding JSON: $e');
      return null;
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
                  cursorColor: GlobalColors.mainColor,
                  decoration: InputDecoration(
                    hintText: '아이디를 입력해주세요.',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide:
                          BorderSide(color: GlobalColors.mainColor, width: 2.0),
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
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide:
                          BorderSide(color: GlobalColors.mainColor, width: 2.0),
                    ),
                  ),
                ),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                )
              else
                SizedBox(height: 22),
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
                          : GlobalColors.lightgray,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          _showFindIdModal(context);
                        },
                        child: const MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            '⯑ 아이디를 잊어버렸어요',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              //decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
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
