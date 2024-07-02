import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool _validatePhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\d{11}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _validateDob(String dob) {
    final dobRegex = RegExp(r'^\d{6}$');
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
          builder: (context) => const SignupStep2(),
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: Text('1', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: Text('2', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '프로필',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('멘토'),
                        value: '멘토',
                        groupValue: _role,
                        onChanged: (value) {
                          setState(() {
                            _role = value;
                            _isRoleValid = true;
                            _validateAllFields();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('멘티'),
                        value: '멘티',
                        groupValue: _role,
                        onChanged: (value) {
                          setState(() {
                            _role = value;
                            _isRoleValid = true;
                            _validateAllFields();
                          });
                        },
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
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('이름', '본명을 알려주세요.'),
                  onChanged: (value) {
                    setState(() {
                      _isNameValid = value.isNotEmpty;
                      _validateAllFields();
                    });
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
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
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
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
                      ),
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
                TextFormField(
                  controller: _dobController,
                  focusNode: _dobFocusNode,
                  decoration: _inputDecoration('생년월일', '6자리 숫자로 입력해주세요.'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
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
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  decoration:
                      _inputDecoration('이메일', '사용하실 이메일을 입력해주세요.').copyWith(
                    suffixIcon: TextButton(
                      onPressed: () {
                        if (_validateEmail(_emailController.text)) {
                          setState(() {
                            _isEmailChecked = true;
                            _isEmailValid = true;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('사용 가능한 이메일입니다!'),
                                backgroundColor: Colors.green,
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
                          color: _isEmailChecked ? Colors.blue : Colors.grey,
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
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  decoration: _inputDecoration('전화번호', '11자리 숫자로 입력해주세요.'),
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
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  focusNode: _addressFocusNode,
                  decoration: _inputDecoration('거주지역', '거주지역을 알려주세요.'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[^\d]')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _validateAllFields();
                    });
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isStep1Valid() ? _goToStep2 : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isStep1Valid() ? Colors.blue : Colors.grey,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('다음'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
