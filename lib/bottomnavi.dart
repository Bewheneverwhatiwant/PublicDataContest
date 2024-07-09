import 'package:flutter/material.dart';

class BottomNavi extends StatefulWidget {
  final Function(int) onTabTapped;
  final int currentIndex;

  const BottomNavi(
      {super.key, required this.onTabTapped, required this.currentIndex});

  @override
  BottomNaviState createState() => BottomNaviState();
}

class BottomNaviState extends State<BottomNavi> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      onTap: widget.onTabTapped,
      currentIndex: widget.currentIndex,
      selectedItemColor: const Color(0xFF6F79F7),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: '채팅',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '마이',
        ),
      ],
    );
  }
}
