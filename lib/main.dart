import 'package:flutter/material.dart';
import 'package:publicdatacontest/appbar/home_appbar.dart';
import 'package:publicdatacontest/mainpage/maincarousel/maincarousel_all/hone_review_all.dart';
import 'package:publicdatacontest/mypage/menti/profile_menti.dart';
import 'mainpage/mainpage.dart';
import 'bottomnavi.dart';
import 'mainpage/banner_gridbuttons/categories/thinking.dart';
import 'mainpage/banner_gridbuttons/categories/photo.dart';
import 'mainpage/banner_gridbuttons/categories/other.dart';
import 'mainpage/banner_gridbuttons/categories/music.dart';
import 'mainpage/banner_gridbuttons/categories/money.dart';
import 'mainpage/banner_gridbuttons/categories/language.dart';
import 'mainpage/banner_gridbuttons/categories/it.dart';
import 'mainpage/banner_gridbuttons/categories/design.dart';
import 'mainpage/banner_gridbuttons/categories/beauty.dart';
import 'mainpage/banner_gridbuttons/categories/all.dart';
import 'mainpage/maincarousel/maincarousel_all/hireintern_all.dart';
import 'mainpage/maincarousel/maincarousel_all/hone_review_all.dart';
import 'mainpage/make_mentoring.dart';
import 'chatingpage/mychatlist.dart';
import 'mypage/mypage.dart';
import 'mypage/mento/profile_mento.dart';
import 'mypage/menti/profile_menti.dart';
import 'mypage/mento/mento_myclass.dart';
import 'mainpage/banner_gridbuttons/categories/mentoring/mentoring_detail.dart';
import 'mainpage/maincarousel/maincarousel_detail/home_review_detail.dart';
import 'mainpage/maincarousel/maincarousel_detail/hireintern_detail.dart';
import 'appbar/login.dart';
import 'appbar/signup.dart';
import 'mainpage/banner_gridbuttons/categories/mentoring/reviewlist.dart';
import 'mainpage/banner_gridbuttons/categories/mentoring/classchat.dart';
import 'mypage/mento/all_review_mento.dart';
import 'splash.dart';

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
      //home: const MyHomePage(),
      home: const SplashPage(),
      routes: {
        '/main': (context) => const MyHomePage(),
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
        '/reviewlist': (context) => const ReviewListPage(),
        '/classchat': (context) => const ClassChatPage(),
        '/allmentoreview': (context) => const AllMentorReviewPage(),
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
