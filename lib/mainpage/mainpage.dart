import 'package:flutter/material.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import '../mainpage/banner_gridbuttons/buttons.dart';
import 'maincarousel/maincarousel_short/hireintern.dart';
import 'maincarousel/maincarousel_short/home_review.dart';
import 'dart:ui';
import 'maincarousel/maincarousel_short/foreignjob.dart';
import 'maincarousel/maincarousel_short/goodforeign.dart';

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
                  // 공공 API 2개에서 key가 등록 안됐다는 오류 나는 중 (분명 등록 승인라고 뜨는데 !!!)
                  // 하두 더 기다려서, key 동기화됐는지 시도해보고... 다른 걸로 바꿀 예정
                  // ForeignJob(),
                  // SizedBox(height: 20),
                  //GoodForeign(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
