import 'package:flutter/material.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';

class MyFieldMentee extends StatelessWidget {
  final List<String> selectedCategories;
  final VoidCallback showCategoryDialog;

  const MyFieldMentee({
    Key? key,
    required this.selectedCategories,
    required this.showCategoryDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('내 구직 분야',
                  style: TextStyle(
                      color: GlobalColors.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              selectedCategories.isEmpty
                  ? const Text(
                      '구직 분야를 추가해주세요.',
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectedCategories.map((category) {
                        return Text(category);
                      }).toList(),
                    ),
            ],
          ),
        ),
        TextButton(
          onPressed: showCategoryDialog,
          style: TextButton.styleFrom(
            backgroundColor: GlobalColors.mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            '추가하기',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
