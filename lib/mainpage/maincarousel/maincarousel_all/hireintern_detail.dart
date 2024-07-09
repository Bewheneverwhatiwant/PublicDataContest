import 'package:flutter/material.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';

// 중장년 인턴 채용 클릭 시 상세화면

class HireInternDetailPage extends StatelessWidget {
  const HireInternDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.whiteColor,
        title: const Text('인턴 채용정보'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: GlobalColors.whiteColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGrayBox('중년인턴'),
              const SizedBox(height: 16),
              _buildGrayBox('중년인턴'),
              const SizedBox(height: 16),
              _buildGrayBox('중년인턴'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrayBox(String text) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
