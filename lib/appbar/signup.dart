import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'signup2.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isEmailChecked = false;
  bool _isEmailValid = false;
  bool _isPhoneValid = false;
  bool _isDobValid = false;
  bool _isRoleValid = false;
  bool _isGenderValid = false;
  bool _isNameValid = false;
  bool _isDobStarted = false;
  bool _isEmailStarted = false;
  bool _isPhoneStarted = false;
  bool _isAddressStarted = false;

  final _formKey = GlobalKey<FormState>();

  // 필드 컨트롤러
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // 포커스 노드
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  // 라디오 버튼 선택 값
  String? _role;
  String? _gender;

  @override
  void initState() {
    super.initState();

    _dobFocusNode.addListener(() {
      if (_dobFocusNode.hasFocus) {
        setState(() {
          _isDobStarted = true;
        });
      }
    });

    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        setState(() {
          _isEmailStarted = true;
        });
      }
    });

    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus) {
        setState(() {
          _isPhoneStarted = true;
        });
      }
    });

    _addressFocusNode.addListener(() {
      if (_addressFocusNode.hasFocus) {
        setState(() {
          _isAddressStarted = true;
        });
      }
    });
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
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

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool _validatePhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\d{11}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _validateDob(String dob) {
    final dobRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return dobRegex.hasMatch(dob);
  }

  bool _isStep1Valid() {
    return _isNameValid &&
        _isEmailValid &&
        _isEmailChecked &&
        _isPhoneValid &&
        _isDobValid &&
        _role != null &&
        _gender != null &&
        _addressController.text.isNotEmpty;
  }

  void _goToStep2() {
    if (_isStep1Valid()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupStep2(
            name: _nameController.text,
            dob: _dobController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            address: _addressController.text,
            role: _role!,
            gender: _gender!,
          ),
        ),
      );
    }
  }

  void _validateAllFields() {
    setState(() {
      _isNameValid = _nameController.text.isNotEmpty;
      _isEmailValid = _validateEmail(_emailController.text);
      _isPhoneValid = _validatePhoneNumber(_phoneController.text);
      _isDobValid = _validateDob(_dobController.text);
      _isRoleValid = _role != null;
      _isGenderValid = _gender != null;
    });
  }

  @override
  void dispose() {
    _dobFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      appBar: AppBar(
        backgroundColor: GlobalColors.whiteColor,
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
          padding: const EdgeInsets.all(35.0),
          child: Align(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '항해에 오신 것을 환영합니다!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: GlobalColors.mainColor,
                        child: Text('1', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: GlobalColors.lightgray,
                        child: Text('2', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        '가입 선택',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                            dense: true,
                            title: Text('멘토'),
                            value: '멘토',
                            groupValue: _role,
                            onChanged: (value) {
                              setState(() {
                                _role = value;
                                _isRoleValid = true;
                                _validateAllFields();
                              });
                            },
                            activeColor: GlobalColors.mainColor),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          dense: true,
                          title: Text('멘티'),
                          value: '멘티',
                          groupValue: _role,
                          onChanged: (value) {
                            setState(() {
                              _role = value;
                              _isRoleValid = true;
                              _validateAllFields();
                            });
                          },
                          activeColor: GlobalColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                  if (_isRoleValid && _role == null)
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        '가입 선택을 해주세요.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const Text(
                    '이름',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('본명을 알려주세요.'),
                    style: TextStyle(fontSize: 13),
                    onChanged: (value) {
                      setState(() {
                        _isNameValid = value.isNotEmpty;
                        _validateAllFields();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        '성별',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 100),
                      Expanded(
                        child: RadioListTile<String>(
                            dense: true,
                            title: const Text('남'),
                            value: '남',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                                _isGenderValid = true;
                                _validateAllFields();
                              });
                            },
                            activeColor: GlobalColors.mainColor),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                            dense: true,
                            title: const Text('여'),
                            value: '여',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                                _isGenderValid = true;
                                _validateAllFields();
                              });
                            },
                            activeColor: GlobalColors.mainColor),
                      ),
                    ],
                  ),
                  if (_isGenderValid && _gender == null)
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        '성별을 선택해주세요.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const Text(
                    '생년월일',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _dobController,
                    focusNode: _dobFocusNode,
                    decoration: _inputDecoration('YYYY-MM-DD 형식으로 입력해주세요.'),
                    style: TextStyle(fontSize: 13),
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d-]')),
                      LengthLimitingTextInputFormatter(10),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          final text = newValue.text;
                          if (text.length == 4) {
                            if (oldValue.text.length == 5) {
                              return TextEditingValue(
                                text: text.substring(0, 4),
                                selection: TextSelection.collapsed(offset: 4),
                              );
                            } else {
                              return TextEditingValue(
                                text: text + '-',
                                selection: TextSelection.collapsed(
                                    offset: text.length + 1),
                              );
                            }
                          }
                          if (text.length == 7) {
                            if (oldValue.text.length == 8) {
                              return TextEditingValue(
                                text: text.substring(0, 7),
                                selection: TextSelection.collapsed(offset: 7),
                              );
                            } else {
                              return TextEditingValue(
                                text: text + '-',
                                selection: TextSelection.collapsed(
                                    offset: text.length + 1),
                              );
                            }
                          }
                          return newValue;
                        },
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _isDobValid = _validateDob(value);
                        _validateAllFields();
                      });
                    },
                  ),
                  if (_isDobStarted && !_isDobValid)
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        '유효한 생년월일을 입력해주세요.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    '이메일',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    style: TextStyle(fontSize: 13),
                    decoration: _inputDecoration('사용하실 이메일을 입력해주세요.').copyWith(
                      suffixIcon: TextButton(
                        onPressed: () {
                          if (_validateEmail(_emailController.text)) {
                            setState(() {
                              _isEmailChecked = true;
                              _isEmailValid = true;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('사용 가능한 이메일입니다!'),
                                  backgroundColor: GlobalColors.darkgray,
                                ),
                              );
                            });
                          } else {
                            setState(() {
                              _isEmailChecked = false;
                              _isEmailValid = false;
                            });
                          }
                          _validateAllFields();
                        },
                        child: Text(
                          '중복검사',
                          style: TextStyle(
                            color: _isEmailChecked
                                ? GlobalColors.mainColor
                                : GlobalColors.darkgray,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isEmailValid = _validateEmail(value);
                        _isEmailChecked = false;
                        _validateAllFields();
                      });
                    },
                  ),
                  if (_isEmailStarted && !_isEmailValid)
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        '유효한 이메일을 입력해주세요.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    '전화번호',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    decoration: _inputDecoration('11자리 숫자로 입력해주세요.'),
                    style: TextStyle(fontSize: 13),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _isPhoneValid = _validatePhoneNumber(value);
                        _validateAllFields();
                      });
                    },
                  ),
                  if (_isPhoneStarted && !_isPhoneValid)
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        '유효한 전화번호를 입력해주세요.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    '거주지역',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    focusNode: _addressFocusNode,
                    decoration: _inputDecoration('거주지역을 알려주세요.'),
                    style: TextStyle(fontSize: 13),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[^\d]')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _validateAllFields();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 60,
              child: ElevatedButton(
                onPressed: _isStep1Valid() ? _goToStep2 : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isStep1Valid()
                      ? GlobalColors.mainColor
                      : GlobalColors.lightgray,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  '다음',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isStep1Valid()
                        ? GlobalColors.whiteColor
                        : GlobalColors.lightgray,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// 필드가 너무 많아서 로그인처럼 테두리색 입히면 난잡해보일까봐 일부러 적용안함. 