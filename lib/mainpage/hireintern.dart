import 'package:flutter/material.dart';

class HireIntern extends StatelessWidget {
  const HireIntern({super.key});

  @override
  Widget build(BuildContext context) {
    const internData = [
      {'사업장명': 'abcd', '모집직종': 'abcd', '근무지역': 'abcd'},
      {'사업장명': 'abcd', '모집직종': 'abcd', '근무지역': 'abcd'},
      {'사업장명': 'abcd', '모집직종': 'abcd', '근무지역': 'abcd'},
      {'사업장명': 'abcd', '모집직종': 'abcd', '근무지역': 'abcd'},
      {'사업장명': 'abcd', '모집직종': 'abcd', '근무지역': 'abcd'},
      {'사업장명': 'abcd', '모집직종': 'abcd', '근무지역': 'abcd'},
      {'사업장명': 'abcd', '모집직종': 'abcd', '근무지역': 'abcd'},
      {'사업장명': 'abcd', '모집직종': 'abcd', '근무지역': 'abcd'},
      {'사업장명': 'abcd', '모집직종': 'abcd', '근무지역': 'abcd'},
      {'사업장명': 'abcd', '모집직종': 'abcd', '근무지역': 'abcd'},
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
                '인턴 채용 정보',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/hireinternall');
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
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: internData.length,
            itemBuilder: (context, index) {
              final intern = internData[index];
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '사업장명 : ${intern['사업장명']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'D-n',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '모집직종 : ${intern['모집직종']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '근무지역 : ${intern['근무지역']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
