import 'package:flutter/material.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import '../mainpage/banner_gridbuttons/buttons.dart';
import 'maincarousel/maincarousel_short/hireintern.dart';
import 'maincarousel/maincarousel_short/home_review.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMento = true; // 멘토인지 멘티인지에 따라 '멘토링 개설' 버튼 조건부 렌더링을 위해 임시 처리!

    return Container(
      color: GlobalColors.whiteColor,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/banner_home.png'),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
            const SizedBox(height: 10),
            const Buttons(),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const HireIntern(),
                  const SizedBox(height: 20),
                  const HomeReview(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
