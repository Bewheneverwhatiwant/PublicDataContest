import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostReviewPage extends StatefulWidget {
  const PostReviewPage({Key? key}) : super(key: key);

  @override
  _PostReviewPageState createState() => _PostReviewPageState();
}

class _PostReviewPageState extends State<PostReviewPage> {
  int _rating = 0;
  TextEditingController _commentController = TextEditingController();
  late int _classId;
  late int _id;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null) {
        setState(() {
          _classId = arguments['classId'] ?? 0;
          _id = arguments['id'] ?? 0;
        });
      } else {
        setState(() {
          _classId = 0;
          _id = 0;
        });
      }
    });
  }

  void _submitReview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.post(
      Uri.parse('${dotenv.env['API_SERVER']}/api/review'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'rating': _rating,
        'comment': _commentController.text,
        'classId': _classId,
        'paymentStatusHistoryID': _id,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('성공적으로 리뷰가 등록되었습니다!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/classreview', arguments: {
        'classId': _classId,
      });
    } else {
      print(_rating);
      print(_commentController.text);
      print(_classId);
      print(_id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('리뷰 등록에 실패했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멘토링 리뷰'),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '이 멘토링, 어떠셨나요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: index < _rating ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '멘티님의 후기를 들려주세요.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _submitReview,
                child: const Text('리뷰 쓰기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
