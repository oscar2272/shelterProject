import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:shelterapp/models/shelter_model.dart';
import 'package:shelterapp/provider/user_provider.dart';
import 'package:shelterapp/services/shelter_service.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});
  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  ShelterModel? shelter;
  late double capacity;
  String? facilityName;
  late UserController userState;
  @override
  void initState() {
    super.initState();
    userState = Provider.of<UserController>(context, listen: false);
    userState.fetchUserData();
  }

  Future<ShelterModel?> fetchShelter() async {
    if (userState.shelterId != null) {
      return await ShelterService.getShelterById(userState.shelterId!);
    } else {
      return null;
    }
  }

  final colorList = <Color>[
    Colors.orangeAccent,
  ];
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double height = screenSize.height;
    double width = screenSize.width;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.05),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              width: width * 0.75,
              height: height * 0.5,
              decoration: BoxDecoration(
                color: const Color(0xFFf8f4ec),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.075, vertical: height * 0.04),
                child: FutureBuilder(
                  future: fetchShelter(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // 데이터를 가져오는 중이므로 로딩 스피너를 표시합니다.
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      int? temp = snapshot.data!.shelterId.toInt();

                      return Column(
                        children: [
                          Text(
                            snapshot.data!.facilityName, //바꿀부분
                            style: const TextStyle(
                              fontFamily: "BlackHanSans",
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 80, 82, 65),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          PieChart(
                            dataMap: <String, double>{
                              "현재인원": snapshot.data!.capacityCount!.toDouble(),
                            },
                            chartType: ChartType.ring,
                            initialAngleInDegree: 0,
                            legendOptions: const LegendOptions(
                              showLegends: true,
                            ),
                            animationDuration: const Duration(seconds: 3),
                            baseChartColor:
                                const Color.fromARGB(255, 133, 98, 98)
                                    .withOpacity(0.15),
                            colorList: colorList,
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                            totalValue:
                                snapshot.data!.capacity!.toDouble(), //바꿀부분
                          ),
                          SizedBox(
                            height: height * 0.13,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                          const TextStyle(color: Colors.white)),
                                ),
                                onPressed: () {
                                  userState.logout(context);
                                },
                                icon: const Icon(
                                  Icons.exit_to_app,
                                ),
                                label: const Text("로그아웃"),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // 비동기 작업 수행
                                  ShelterService.subtractShelterCapacityCount(
                                    temp,
                                    userState.userId!.toInt(),
                                  ).then((_) {
                                    userState.fetchUserData().then((_) {
                                      setState(() {
                                        userState.shelterId;
                                      });
                                    });

                                    // 비동기 작업이 완료된 후에 추가적인 작업 수행
                                    // 사용자 데이터 다시 가져오기 등의 후처리 작업
                                  });
                                },
                                icon: const Icon(Icons.group_off_outlined),
                                label: const Text(
                                  "나가기",
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    } else if (snapshot.data == null) {
                      return Column(
                        children: [
                          const Text(
                            "대피소에 입장하세요", //바꿀부분
                            style: TextStyle(
                              fontFamily: "BlackHanSans",
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 80, 82, 65),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          PieChart(
                            dataMap: const <String, double>{
                              "현재인원": 0,
                            }, //수정할부분
                            chartType: ChartType.ring,
                            initialAngleInDegree: 0,
                            legendOptions: const LegendOptions(
                              showLegends: true,
                            ),
                            animationDuration: const Duration(seconds: 3),
                            baseChartColor:
                                const Color.fromARGB(255, 133, 98, 98)
                                    .withOpacity(0.15),
                            colorList: colorList,
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                            totalValue: 20, //바꿀부분
                          ),
                          SizedBox(
                            height: height * 0.13,
                          ),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                  const TextStyle(color: Colors.white)),
                            ),
                            onPressed: () {
                              userState.logout(context);
                            },
                            icon: const Icon(
                              Icons.exit_to_app,
                            ),
                            label: const Text("로그아웃"),
                          )
                        ],
                      );
                    } else {
                      return Text('Error: ${snapshot.error}');
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
