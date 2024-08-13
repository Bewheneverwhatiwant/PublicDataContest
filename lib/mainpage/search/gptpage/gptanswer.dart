import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/services.dart' show rootBundle;

class GPTAnswerPage extends StatefulWidget {
  const GPTAnswerPage({Key? key}) : super(key: key);

  @override
  _GPTAnswerPageState createState() => _GPTAnswerPageState();
}

class _GPTAnswerPageState extends State<GPTAnswerPage> {
  String? answer;

  @override
  void initState() {
    super.initState();

    // 페이지가 새로 로드될 때 answer를 ModalRoute로부터 가져옴
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String? args =
          ModalRoute.of(context)?.settings.arguments as String?;
      if (args != null) {
        setState(() {
          answer = args; // State에 answer를 저장
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '항해의 생성형AI가 자기소개서를 도착했습니다!',
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // 뒤로가기 버튼 숨김
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0),
                height: 600,
                child: SingleChildScrollView(
                  child: Text(
                    answer ?? 'Loading...', // answer가 없으면 로딩 텍스트 표시
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/makepaper');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '재생성하기',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await savePDF(answer ?? 'No content');

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PDF가 저장되었습니다!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'PDF 다운로드',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // '/gptpage'로 이동하기
                      Navigator.pushNamed(context, '/gptpage');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '닫기',
                      style: TextStyle(color: Colors.white),
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

  Future<void> savePDF(String content) async {
    final pdf = pw.Document();

    // 한글 폰트 로드
    final fontData =
        await rootBundle.load('assets/fonts/NotoSansKR-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(content, style: pw.TextStyle(font: ttf)),
        ),
      ),
    );

    final Uint8List bytes = await pdf.save();

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'resume.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
