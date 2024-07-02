import 'package:flutter/material.dart';

class HomeReview extends StatelessWidget {
  const HomeReview({super.key});

  @override
  Widget build(BuildContext context) {
    const reviewData = [
      {'멘토이름': '어쩌구', '수업명': '어쩌구', '별수': 5, '설명': 'abcdefg'},
      {'멘토이름': '어쩌구', '수업명': '어쩌구', '별수': 4, '설명': 'abcdefg'},
      {'멘토이름': '어쩌구', '수업명': '어쩌구', '별수': 3, '설명': 'abcdefg'},
      {'멘토이름': '어쩌구', '수업명': '어쩌구', '별수': 5, '설명': 'abcdefg'},
      {'멘토이름': '어쩌구', '수업명': '어쩌구', '별수': 4, '설명': 'abcdefg'},
      {'멘토이름': '어쩌구', '수업명': '어쩌구', '별수': 5, '설명': 'abcdefg'},
      {'멘토이름': '어쩌구', '수업명': '어쩌구', '별수': 3, '설명': 'abcdefg'},
      {'멘토이름': '어쩌구', '수업명': '어쩌구', '별수': 4, '설명': 'abcdefg'},
      {'멘토이름': '어쩌구', '수업명': '어쩌구', '별수': 5, '설명': 'abcdefg'},
      {'멘토이름': '어쩌구', '수업명': '어쩌구', '별수': 4, '설명': 'abcdefg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '멘토링 리뷰',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/homereviewall');
                },
                child: const Text(
                  '전체보기 >',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: reviewData.length,
            itemBuilder: (context, index) {
              final review = reviewData[index];
              final int stars = review['별수'] as int;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 200,
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
                        '멘토이름: ${review['멘토이름']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '수업명: ${review['수업명']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(stars, (index) {
                          return const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        review['설명'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
