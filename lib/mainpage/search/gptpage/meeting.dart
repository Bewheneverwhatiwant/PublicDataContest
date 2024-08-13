import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeetingPage extends StatefulWidget {
  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  final TextEditingController companyController =
      TextEditingController(); // 기업명
  final TextEditingController niceController = TextEditingController(); // 인재상

  final List<TextEditingController> certificationControllers = [];
  final List<TextEditingController> careerPeriodFromControllers = [];
  final List<TextEditingController> careerPeriodToControllers = [];
  final List<TextEditingController> careerCompanyControllers = [];
  final List<TextEditingController> careerPositionControllers = [];
  final List<TextEditingController> careerDutyControllers = [];
  final List<TextEditingController> careerReasonControllers = [];

  @override
  void initState() {
    super.initState();
    // 자격증과 경력사항에 각각 하나의 필드를 기본으로 추가
    certificationControllers.add(TextEditingController());
    careerPeriodFromControllers.add(TextEditingController());
    careerPeriodToControllers.add(TextEditingController());
    careerCompanyControllers.add(TextEditingController());
    careerPositionControllers.add(TextEditingController());
    careerDutyControllers.add(TextEditingController());
    careerReasonControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    // 모든 컨트롤러를 해제하여 메모리 누수를 방지
    certificationControllers.forEach((controller) => controller.dispose());
    careerPeriodFromControllers.forEach((controller) => controller.dispose());
    careerPeriodToControllers.forEach((controller) => controller.dispose());
    careerCompanyControllers.forEach((controller) => controller.dispose());
    careerPositionControllers.forEach((controller) => controller.dispose());
    careerDutyControllers.forEach((controller) => controller.dispose());
    careerReasonControllers.forEach((controller) => controller.dispose());

    majorController.dispose();
    gradeController.dispose();
    jobController.dispose();

    companyController.dispose();
    niceController.dispose();

    super.dispose();
  }

  Future<void> sendMessageToGPT(String message) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('면접이 준비되고 있어요...'),
          ],
        ),
      ),
    );

    try {
      // 환경 변수 불러오기
      String apiKey = dotenv.env['GPT_KEY'] ?? '';

      if (apiKey.isEmpty) {
        throw Exception('Missing GPT_KEY');
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      var requestBody = jsonEncode({
        'model': 'gpt-4-turbo',
        'messages': [
          {'role': 'user', 'content': message}
        ]
      });

      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var responseBody = utf8.decode(response.bodyBytes);
        var decodedResponse = json.decode(responseBody);

        if (decodedResponse['choices'] != null &&
            decodedResponse['choices'].isNotEmpty) {
          var MeetingAsk = decodedResponse['choices'][0]['message']['content'];

          if (MeetingAsk != null) {
            Navigator.pop(context); // 로딩 모달 닫기
            //print(MeetingAsk);

// 만들어진 10개의 질문 리스트를 argument로 전달
            Navigator.pushNamed(
              context,
              '/gptmeeting',
              arguments: MeetingAsk,
            );
          } else {
            // assistantMessage가 null일 때의 처리
            print('Error: MeetingAsk is null');
            print(response.body);
          }
        } else {
          // choices가 비어있거나 null일 때의 처리
          print('Error: No choices returned from GPT');
          print(response.body);
        }
      } else {
        print('gpt의 응답을 받는 중에 오류발생');
        print(response.body);
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/icon_ai.png',
          width: 40,
          height: 40,
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '항해의 생성형AI가 면접을 대비해드릴게요.',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: companyController,
                  decoration: const InputDecoration(
                    labelText: '기업명',
                    border: OutlineInputBorder(),
                    hintText: '희망하시는 기업명을 알려주세요.',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '기업명은 필수 입력 항목입니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: niceController,
                  decoration: const InputDecoration(
                    labelText: '인재상',
                    border: OutlineInputBorder(),
                    hintText: '기업의 인재상이 있다면 알려주세요.',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: majorController,
                  decoration: const InputDecoration(
                    labelText: '전공',
                    border: OutlineInputBorder(),
                    hintText: '이중전공, 부전공이 있다면 함께 기재해주세요.',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '전공은 필수 입력 항목입니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: gradeController,
                        decoration: const InputDecoration(
                          labelText: '학점',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '학점은 필수 입력 항목입니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '/ 4.5',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: jobController,
                  decoration: const InputDecoration(
                    labelText: '지원분야(직무)',
                    border: OutlineInputBorder(),
                    hintText: '구체적으로 작성해주세요.',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '직무는 필수 입력 항목입니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '자격증',
                      style: TextStyle(fontSize: 16),
                    ),
                    Column(
                      children: certificationControllers.map((controller) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          certificationControllers.add(TextEditingController());
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '경력사항',
                  style: TextStyle(fontSize: 16),
                ),
                Column(
                  children:
                      List.generate(careerCompanyControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '근무기간',
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        careerPeriodFromControllers[index],
                                    decoration: const InputDecoration(
                                      labelText: '부터',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        careerPeriodToControllers[index],
                                    decoration: const InputDecoration(
                                      labelText: '까지',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: careerCompanyControllers[index],
                              decoration: const InputDecoration(
                                labelText: '회사명',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: careerPositionControllers[index],
                              decoration: const InputDecoration(
                                labelText: '직위',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: careerDutyControllers[index],
                              decoration: const InputDecoration(
                                labelText: '담당업무',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: careerReasonControllers[index],
                              decoration: const InputDecoration(
                                labelText: '퇴사사유',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      careerPeriodFromControllers.add(TextEditingController());
                      careerPeriodToControllers.add(TextEditingController());
                      careerCompanyControllers.add(TextEditingController());
                      careerPositionControllers.add(TextEditingController());
                      careerDutyControllers.add(TextEditingController());
                      careerReasonControllers.add(TextEditingController());
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // 각 TextEditingController를 사용하여 입력된 값을 가져온다
                      String major = majorController.text; // 전공
                      String grade = gradeController.text; // 학점
                      String job = jobController.text; // 직무
                      String company = companyController.text; // 기업명
                      String nice = niceController.text; // 인재상

                      String certifications = certificationControllers
                          .map((c) => c.text)
                          .join(", ");
                      String careers = List.generate(
                          careerCompanyControllers.length, (index) {
                        return '${index + 1}.\n'
                            '근무기간: ${careerPeriodFromControllers[index].text} 부터 ${careerPeriodToControllers[index].text}까지,\n'
                            '회사명: ${careerCompanyControllers[index].text},\n'
                            '직위: ${careerPositionControllers[index].text},\n'
                            '담당업무: ${careerDutyControllers[index].text},\n'
                            '퇴사사유: ${careerReasonControllers[index].text}.';
                      }).join("\n\n");

                      String message =
                          '내가 전달하는 정보를 바탕으로, 10개의 면접 질문을 생성하라.\n면접관의 입장에서 물어볼 것 같은 질문을 생성해야 한다.\n이때, 대괄호 등 특수문자가 포함되어서는 안된다.\n'
                          '만들어진 질문 10개는 항상 1번부터 10번까지 번호가 각 질문 앞에 매겨져있어야 하고, 각 질문마다 행을 나누어달라. 10개의 질문 외 다른 말은 덧붙이지 마라. 항상 이러한 형식으로 전달해야 한다.'
                          '면접을 대비하고자 하는 기업 이름: $company\n'
                          '면접을 대비하고자 하는 기업의 인재상: $nice\n'
                          '전공: $major, 학점: $grade, 지원분야(직무): $job,\n'
                          '자격증: $certifications,\n'
                          '경력사항:\n$careers';

                      sendMessageToGPT(message); // GPT에게 메시지 전송
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('전공, 학점, 직무는 반드시 입력하셔야 합니다.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('면접 시작하기',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
