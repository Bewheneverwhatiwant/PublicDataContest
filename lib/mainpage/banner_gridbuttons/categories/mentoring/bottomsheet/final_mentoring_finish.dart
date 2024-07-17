import 'package:flutter/material.dart';

class FinalMentoringFinishPage extends StatelessWidget {
  final String timestamp;
  final int conversationId;

  const FinalMentoringFinishPage({
    Key? key,
    required this.timestamp,
    required this.conversationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth / 1.5,
      height: 200,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Image.asset(
                        'images/logo.png',
                        width: 60,
                        height: 40,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '모든 멘토링이 종료되었습니다.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '멘토링을 통해 더욱 성장하신 것을 축하드립니다.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Hang Hae',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 25,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () {
                                    _showReportModal(context);
                                  },
                                  child: const Text(
                                    '사용자 신고',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReportModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController reportController = TextEditingController();
        return AlertDialog(
          title: const Text('사용자 신고'),
          content: TextField(
            controller: reportController,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: '신고 사유를 작성해주세요. 구체적일 수록 좋아요. 3일 내 관리자가 확인하여 조치될 예정입니다.',
              hintStyle: TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('사용자 신고가 완료되었습니다!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
