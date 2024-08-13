import 'package:flutter/material.dart';

class MakePaperPage extends StatefulWidget {
  @override
  _MakePaperPageState createState() => _MakePaperPageState();
}

class _MakePaperPageState extends State<MakePaperPage> {
  final _formKey = GlobalKey<FormState>();
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
    super.dispose();
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
                  '항해의 생성형AI가 자기소개서 작성을 도와드릴게요.',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                TextFormField(
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
                      '/ 4.5(4.3)',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
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
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        careerPeriodToControllers[index],
                                    decoration: const InputDecoration(
                                      labelText: '00년00월00일부터',
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
                                      labelText: '00년00월00일까지',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 350,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // 필수 입력 항목이 모두 채워진 경우
                            // 자기소개서 생성 로직 실행
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
                        child: const Text('자기소개서 생성하기',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
