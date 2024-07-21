import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeReviewDetailPage extends StatefulWidget {
  const HomeReviewDetailPage({Key? key}) : super(key: key);

  @override
  _HomeReviewDetailPageState createState() => _HomeReviewDetailPageState();
}

class _HomeReviewDetailPageState extends State<HomeReviewDetailPage> {
  Map<String, dynamic>? reviewDetail;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final int reviewId = arguments?['reviewId'];
      if (reviewId != null) {
        _fetchReviewDetail(reviewId);
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    });
  }

  Future<void> _fetchReviewDetail(int reviewId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse(
            '${dotenv.env['API_SERVER']}/api/review/detail?reviewId=$reviewId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          reviewDetail = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: const Text('멘토링 리뷰'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError || reviewDetail == null) {
      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: const Text('멘토링 리뷰'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const Center(child: Text('리뷰 정보를 불러오는데 실패했습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('멘토링 리뷰'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '멘토링 정보',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildMentoringInfo(),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '멘티 리뷰',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildMenteeReview(),
          ],
        ),
      ),
    );
  }

  Widget _buildMentoringInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '멘토링명: ${reviewDetail?['className'] ?? '없음'}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '멘토: ${reviewDetail?['menteeName'] ?? '없음'}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMenteeReview() {
    final int stars = reviewDetail?['rating'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '평점',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Row(
              children: List.generate(stars, (index) {
                return const Icon(
                  Icons.star,
                  color: Colors.yellow,
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          reviewDetail?['comment'] ?? '내용 없음',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
