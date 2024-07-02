import 'package:flutter/material.dart';
import 'package:publicdatacontest/appbar/home_appbar.dart';
import 'package:publicdatacontest/mainpage/maincarousel_all/hone_review_all.dart';
import 'package:publicdatacontest/mypage/profile_menti.dart';
import 'mainpage/mainpage.dart';
import 'bottomnavi.dart';
import 'mainpage/categories/thinking.dart';
import 'mainpage/categories/photo.dart';
import 'mainpage/categories/other.dart';
import 'mainpage/categories/music.dart';
import 'mainpage/categories/money.dart';
import 'mainpage/categories/language.dart';
import 'mainpage/categories/it.dart';
import 'mainpage/categories/design.dart';
import 'mainpage/categories/beauty.dart';
import 'mainpage/categories/all.dart';
import 'mainpage/maincarousel_all/hireintern_all.dart';
import 'mainpage/maincarousel_all/hone_review_all.dart';
import 'mainpage/make_mentoring.dart';
import 'chatingpage/mychatlist.dart';
import 'mypage/mypage.dart';
import 'mypage/profile_mento.dart';
import 'mypage/profile_menti.dart';
import 'mypage/mento_myclass.dart';
import 'mainpage/categories/mentoring_detail.dart';
import 'mainpage/maincarousel_detail/home_review_detail.dart';
import 'mainpage/maincarousel_detail/hireintern_detail.dart';
import 'appbar/login.dart';
import 'appbar/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HangHae',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      routes: {
        '/thinking': (context) => const ThinkingPage(),
        '/photo': (context) => const PhotoPage(),
        '/other': (context) => const OtherPage(),
        '/music': (context) => const MusicPage(),
        '/money': (context) => const MoneyPage(),
        '/language': (context) => const LanguagePage(),
        '/it': (context) => const ITPage(),
        '/design': (context) => const DesignPage(),
        '/beauty': (context) => const BeautyPage(),
        '/all': (context) => const AllPage(),
        '/hireinternall': (context) => const HireInternAll(),
        '/homereviewall': (context) => const HomeReviewAll(),
        '/makementoring': (context) => const MakeMentoring(),
        '/profilemento': (context) => const ProfileMentoPage(),
        '/profilementi': (context) => const ProfileMentiPage(),
        '/mentomyclass': (context) => const MentoMyClassPage(),
        '/mentoringdetail': (context) => const MentoringDetailPage(),
        '/reviewdetail': (context) => const HomeReviewDetailPage(),
        '/hireinterndetail': (context) => const HireInternDetailPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const MainPage(),
    const MyChatList(),
    const MyPage(isMento: true), // 요기 조정해서 멘토, 멘티의 마이페이지 UI 확인 가능
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(
        logoPath: 'assets/images/logo.png',
        logoWidth: 60.0,
        logoHeight: 40.0,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavi(
        onTabTapped: onTabTapped,
        currentIndex: _currentIndex,
      ),
    );
  }
}
