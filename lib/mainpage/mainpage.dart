import 'package:flutter/material.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import '../mainpage/banner_gridbuttons/buttons.dart';
import 'maincarousel/maincarousel_short/hireintern.dart';
import 'maincarousel/maincarousel_short/home_review.dart';
import 'dart:ui';
import 'maincarousel/maincarousel_short/foreignjob.dart';
import 'maincarousel/maincarousel_short/goodforeign.dart';
import 'maincarousel/maincarousel_short/foreignmento.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalColors.whiteColor,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/banner_home.png'),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/searchclass');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Text('원하는 멘토링을 검색하세요.',
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/searchclass');
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   width: 2.0,
                    //   color: const Color(0xFF33CBAC),
                    // ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF33CBAC), Color(0xFF1089E4)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '생성형 AI가 서류와 면접을 도와드려요.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.important_devices, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Buttons(),
            const Padding(
              padding: EdgeInsets.only(
                  left: 25.0, bottom: 25.0, top: 25.0, right: 20.0),
              child: Column(
                children: [
                  HireIntern(),
                  SizedBox(height: 20),
                  HomeReview(),
                  SizedBox(height: 20),
                  // 밑에 공공API 3개: ENCODE 키 쓰면 키 미등록 에러, DECODE 키 쓰면 ROUTING 에러나는 중.
                  // 이해를 할 수 없음.
                  // ForeignJob(),
                  // SizedBox(height: 20),
                  // GoodForeign(),
                  // ForeignMento(), <- 기다려보고 안되면 키 재발급받아서 다시 해보기.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
