import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChangePasswordButton extends StatefulWidget {
  final VoidCallback onClose;

  const ChangePasswordButton({Key? key, required this.onClose})
      : super(key: key);

  @override
  _ChangePasswordButtonState createState() => _ChangePasswordButtonState();
}

class _ChangePasswordButtonState extends State<ChangePasswordButton> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordValid = false;
  bool _doPasswordsMatch = true;
  bool _isFormValid = false;

  void _validateForm() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~]).{6,11}$');
    setState(() {
      _isPasswordValid = passwordRegex.hasMatch(password);
      _doPasswordsMatch = password == confirmPassword;
      _isFormValid = _isPasswordValid && _doPasswordsMatch;
    });
  }

  Future<void> _changePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final url =
        '${dotenv.env['API_SERVER']}/api/auth/change_password?new_password=${_passwordController.text}';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // _logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('비밀번호 변경이 완료되었습니다!'),
          backgroundColor: Colors.green,
        ),
      );
      _logout();
      widget.onClose();
      _resetForm();
    } else {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('비밀번호 변경에 실패했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');

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

  void _resetForm() {
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _isPasswordValid = false;
      _doPasswordsMatch = true;
      _isFormValid = false;
    });
  }

  void _showChangePasswordModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void _localValidateForm() {
              final password = _passwordController.text;
              final confirmPassword = _confirmPasswordController.text;

              final passwordRegex =
                  RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~]).{6,11}$');
              setState(() {
                _isPasswordValid = passwordRegex.hasMatch(password);
                _doPasswordsMatch = password == confirmPassword;
                _isFormValid = _isPasswordValid && _doPasswordsMatch;
              });
            }

            return AlertDialog(
              title: const Text('비밀번호 변경'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '새로운 비밀번호를 입력하세요.',
                      errorText: _isPasswordValid
                          ? null
                          : '대문자 1개, 특수문자 1개 포함, 6-11자리여야 합니다.',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    onChanged: (value) {
                      _localValidateForm();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '한번 더 입력하세요.',
                      errorText: _doPasswordsMatch ? null : '비밀번호가 일치하지 않습니다.',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    onChanged: (value) {
                      _localValidateForm();
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetForm();
                  },
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: _isFormValid
                      ? () async {
                          await _changePassword();
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      _resetForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          _showChangePasswordModal(context);
        },
        child: const Text(
          '비밀번호 변경',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
