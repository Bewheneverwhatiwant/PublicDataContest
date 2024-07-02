import 'package:flutter/material.dart';
import 'buttons.dart';
import 'hireintern.dart';
import 'home_review.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMento = true; // 멘토인지 멘티인지에 따라 '멘토링 개설' 버튼 조건부 렌더링을 위해 임시 처리!

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Image.asset('assets/images/banner_home.png'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '원하는 멘토링을 검색하세요',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Buttons(isMento: isMento),
          const HireIntern(),
          const HomeReview(),
        ],
      ),
    );
  }
}
