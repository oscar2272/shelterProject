import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:shelterapp/models/shelter_area_model.dart';
import 'package:shelterapp/screens/shelter_list_screen.dart';
import 'package:shelterapp/services/search_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<ShelterSearchModel>> sido;
  late Future<List<ShelterSearchModel>>? sigungu;

  String? selectedSidoName;
  String? selectedSigunguName;
  @override
  void initState() {
    super.initState();
    sido = SearchService.getSido();
    sigungu = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        foregroundColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "검색",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/map.png',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "지역 선택",
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedSidoName = null;
                      selectedSigunguName = null;
                    });
                  },
                  icon: const Icon(Icons.cancel_rounded),
                ),
              ],
            ),
            const SizedBox(height: 5),
            FutureBuilder(
              future: sido,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final List<ShelterSearchModel> items =
                      List.of(snapshot.data!);
                  return DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: const Color.fromRGBO(108, 99, 99, 0.13),
                      filled: true,
                    ),
                    value: selectedSidoName,
                    onChanged: (value) {
                      setState(() {
                        selectedSidoName = value;
                        selectedSigunguName = null;
                        if (selectedSidoName == null) {
                          selectedSigunguName = null; // 선택된 시군구 초기화
                        } else {
                          sigungu = SearchService.getSigungu(selectedSidoName!);
                        }
                      });
                    },
                    menuMaxHeight: 300,
                    items: [
                      // "-" 옵션 추가
                      const DropdownMenuItem(
                        // "-" 값을 설정
                        child: Text('-'), // "-" 텍스트
                      ),
                      ...items.map(
                        (sido) {
                          return DropdownMenuItem(
                            value: sido.sidoName,
                            child: Text(sido.sidoName),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder(
              future: sigungu,
              builder: (context, snapshot) {
                if (selectedSidoName == null) {
                  // 시/도가 "-"인 경우, 시/군/구를 조회하지 않음
                  selectedSigunguName = null;
                  // 빈 SizedBox를 반환하여 아무 내용도 표시하지 않음
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // 에러가 발생한 경우 "-"를 선택된 값으로 설정
                  selectedSigunguName = null;
                }

                return DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: const Color.fromRGBO(108, 99, 99, 0.13),
                    filled: true,
                  ),
                  value: selectedSigunguName,
                  onChanged: (value) {
                    setState(() {
                      selectedSigunguName = value;
                    });
                  },
                  menuMaxHeight: 300,
                  items: [
                    // "-" 옵션 추가
                    const DropdownMenuItem(
                      // "-" 값을 설정
                      child: Text('-'), // "-" 텍스트
                    ),
                    // 실제 시군구 목록 추가
                    if (snapshot.hasData)
                      ...snapshot.data!.map(
                        (sigungu) {
                          return DropdownMenuItem(
                            value: sigungu.sigunguName,
                            child: Text(sigungu.sigunguName),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), // 버튼의 최소 크기 지정
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShelterListScreen(
                      sidoName: selectedSidoName,
                      sigunguName: selectedSigunguName,
                    ),
                  ),
                );
              },
              child: const Text(
                '대피소 검색',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () {},
                child: const Text(
                  '위치기반 검색',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
