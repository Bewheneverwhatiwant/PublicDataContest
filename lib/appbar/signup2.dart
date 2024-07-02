import 'package:flutter/material.dart';

class SignupStep2 extends StatefulWidget {
  const SignupStep2({super.key});

  @override
  _SignupStep2State createState() => _SignupStep2State();
}

class _SignupStep2State extends State<SignupStep2> {
  bool _isUsernameChecked = false;
  bool _isUsernameValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _isPasswordMatched = false;
  bool _isUsernameStarted = false;
  bool _isPasswordStarted = false;
  bool _isConfirmPasswordStarted = false;
  bool _isTermsChecked = false;
  bool _isPrivacyChecked = false;
  bool _isAdConsentChecked = false;

  final _formKey = GlobalKey<FormState>();

  // 필드 컨트롤러
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // 포커스 노드
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _usernameFocusNode.addListener(() {
      if (_usernameFocusNode.hasFocus) {
        setState(() {
          _isUsernameStarted = true;
        });
      }
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        setState(() {
          _isPasswordStarted = true;
        });
      }
    });

    _confirmPasswordFocusNode.addListener(() {
      if (_confirmPasswordFocusNode.hasFocus) {
        setState(() {
          _isConfirmPasswordStarted = true;
        });
      }
    });
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }

  bool _validateUsername(String username) {
    return username.isNotEmpty;
  }

  bool _validatePassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[!@#\$&*~])(?=.*[0-9]).{8,14}$');
    return passwordRegex.hasMatch(password);
  }

  bool _isStep2Valid() {
    return _isUsernameValid &&
        _isUsernameChecked &&
        _isPasswordValid &&
        _isConfirmPasswordValid &&
        _isPasswordMatched;
  }

  void _validateAllFields() {
    setState(() {
      _isUsernameValid = _validateUsername(_usernameController.text);
      _isPasswordValid = _validatePassword(_passwordController.text);
      _isConfirmPasswordValid =
          _passwordController.text == _confirmPasswordController.text;
      _isPasswordMatched =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '항해에 오신 것을 환영합니다!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: const Text('1',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: const Text('2',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '로그인 정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  decoration:
                      _inputDecoration('아이디', '사용하실 아이디를 입력해주세요.').copyWith(
                    suffixIcon: TextButton(
                      onPressed: () {
                        if (_validateUsername(_usernameController.text)) {
                          setState(() {
                            _isUsernameChecked = true;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('사용 가능한 아이디입니다!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          });
                        } else {
                          setState(() {
                            _isUsernameChecked = false;
                          });
                        }
                        _validateAllFields();
                      },
                      child: Text(
                        '중복검사',
                        style: TextStyle(
                          color: _isUsernameChecked ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isUsernameValid = _validateUsername(value);
                      _isUsernameChecked = false;
                      _validateAllFields();
                    });
                  },
                ),
                if (_isUsernameStarted && !_isUsernameValid)
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      '유효한 아이디를 입력해주세요.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: true,
                  decoration: _inputDecoration('비밀번호', '비밀번호를 입력해주세요.'),
                  onChanged: (value) {
                    setState(() {
                      _isPasswordValid = _validatePassword(value);
                      _isPasswordMatched =
                          value == _confirmPasswordController.text;
                      _validateAllFields();
                    });
                  },
                ),
                if (_isPasswordStarted && !_isPasswordValid)
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      '비밀번호는 특수문자 1개 이상, 숫자 1개 이상, 8글자 이상, 14글자 이하여야 합니다.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  obscureText: true,
                  decoration: _inputDecoration('비밀번호 확인', '비밀번호를 다시 입력해주세요.'),
                  onChanged: (value) {
                    setState(() {
                      _isConfirmPasswordValid =
                          value == _passwordController.text;
                      _isPasswordMatched = value == _passwordController.text;
                      _validateAllFields();
                    });
                  },
                ),
                if (_isConfirmPasswordStarted && !_isConfirmPasswordValid)
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      '비밀번호가 일치하지 않습니다.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isStep2Valid()
                      ? () {
                          _showBottomSheet();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isStep2Valid() ? Colors.blue : Colors.grey,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('입력 완료'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '약관 전체동의',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  CheckboxListTile(
                    title: const Text('이용약관 동의 (필수)'),
                    value: _isTermsChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isTermsChecked = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('개인정보 수집 및 이용동의 (필수)'),
                    value: _isPrivacyChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isPrivacyChecked = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('E-mail 및 SMS 광고성 정보 수신 동의'),
                    value: _isAdConsentChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAdConsentChecked = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isTermsChecked && _isPrivacyChecked
                        ? () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('회원가입되었습니다!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
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
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isTermsChecked && _isPrivacyChecked
                          ? Colors.blue
                          : Colors.grey,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('회원가입'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
