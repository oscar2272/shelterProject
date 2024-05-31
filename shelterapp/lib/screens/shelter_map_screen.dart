import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';
import 'package:shelterapp/models/shelter_model.dart';
import 'package:shelterapp/provider/user_provider.dart';
import 'package:shelterapp/services/shelter_service.dart';

class ShelterMapScreen extends StatefulWidget {
  final String? sidoName, sigunguName;
  final int shelterId;
  final double latitude, longitude;
  final double distance;
  const ShelterMapScreen({
    super.key,
    required this.shelterId,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.sidoName,
    required this.sigunguName,
  });

  @override
  State<ShelterMapScreen> createState() => _ShelterMapScreenState();
}

class _ShelterMapScreenState extends State<ShelterMapScreen> {
  Future<ShelterModel>? shelter;
  late Future<List<ShelterModel>> shelters;
  late bool isEntered;
  late bool isButtonPressed;
  @override
  void initState() {
    super.initState();
    shelter = ShelterService.getShelterById(widget.shelterId);
    Provider.of<UserController>(context, listen: false)
        .fetchUserData()
        .then((_) {
      //isEnter --> 버튼 구분
      //isAllowed --> 입장 로직
      setState(() {
        if (Provider.of<UserController>(context, listen: false).shelterId ==
            null) {
          isEntered = false; // 입장 가능
        } else if (Provider.of<UserController>(context, listen: false)
                .shelterId ==
            widget.shelterId) {
          isEntered = true; // 퇴장만 가능
        } else {
          isEntered = false; // 다른 대피소에 이미 입장 중
        }
      });
    });
    isButtonPressed = false;
  }

  bool isEntryAllowed(double distance, int capacity, int capacityCount) {
    if (Provider.of<UserController>(context, listen: false).shelterId != null) {
      isEntered = true;
    }
    // 현재 사용자가 다른 대피소에 이미 입장 중이거나 용량이 초과되면 입장할 수 없도록 설정
    return isEntered == false && distance <= 250 && capacity > capacityCount;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double height = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, isButtonPressed); // 뒤로가기 동작
          },
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        foregroundColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "대피소 지도",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: FutureBuilder<ShelterModel>(
        future: shelter,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final shelterData = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          shelterData.facilityName,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 19,
                            color: Color(0xFF7E5353),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showBottomSheet(
                            enableDrag: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 213, 143, 143),
                                  width: 2),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter bottomState) {
                                  return FutureBuilder(
                                    future: shelter,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          decoration: const BoxDecoration(
                                              //color: Color(0xFFff9700),
                                              ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 30),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // BottomSheet를 닫음
                                                  },
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                ),
                                                const Flexible(
                                                  flex: 1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "위치 정보",
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 2,
                                                  child: Row(
                                                    children: [
                                                      const Expanded(
                                                        flex: 1,
                                                        child: Icon(
                                                          Icons.navigation,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          snapshot
                                                              .data!.address,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                          overflow:
                                                              TextOverflow.clip,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Icon(
                                                          Icons.stairs_rounded,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          snapshot
                                                              .data!.location,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      const Expanded(
                                                        flex: 1,
                                                        child: Icon(
                                                          Icons.square,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          '${snapshot.data!.area.toString()} m²',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      const Expanded(
                                                        flex: 1,
                                                        child: Icon(
                                                          Icons
                                                              .reduce_capacity_rounded,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          '${snapshot.data!.capacityCount}/${snapshot.data!.capacity}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      OutlinedButton.icon(
                                                        onPressed: () => (double
                                                                distance,
                                                            int capacity,
                                                            int capacityCount) {
                                                          if (!isEntered) {
                                                            if (isEntryAllowed(
                                                                distance,
                                                                capacity,
                                                                capacityCount)) {
                                                              ShelterService
                                                                  .addShelterCapacityCount(
                                                                widget
                                                                    .shelterId,
                                                                Provider.of<UserController>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .userId ??
                                                                    0,
                                                              ).then((_) {
                                                                setState(() {
                                                                  isButtonPressed =
                                                                      !isButtonPressed;
                                                                  Provider.of<UserController>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .fetchUserData();
                                                                  isEntered =
                                                                      true;
                                                                });
                                                                Future.delayed(
                                                                    Duration
                                                                        .zero,
                                                                    () {
                                                                  bottomState(
                                                                      () {
                                                                    shelter = ShelterService
                                                                        .getShelterById(
                                                                            widget.shelterId);
                                                                  });
                                                                });
                                                              }).catchError(
                                                                  (error) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          "현재 입장할 수 없습니다.")),
                                                                );
                                                              });
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "입장할 수 없습니다.")),
                                                              );
                                                            }
                                                          } else {
                                                            ShelterService.subtractShelterCapacityCount(
                                                                    widget
                                                                        .shelterId,
                                                                    Provider.of<UserController>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .userId!
                                                                        .toInt())
                                                                .then((_) {
                                                              setState(() {
                                                                isButtonPressed =
                                                                    !isButtonPressed;
                                                                Provider.of<UserController>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .fetchUserData();
                                                                isEntered =
                                                                    false; // 퇴장 성공 시 상태 변경
                                                              });
                                                              Future.delayed(
                                                                  Duration.zero,
                                                                  () {
                                                                bottomState(() {
                                                                  shelter = ShelterService
                                                                      .getShelterById(
                                                                          widget
                                                                              .shelterId);
                                                                });
                                                              });
                                                            }).catchError(
                                                                    (error) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "현재 퇴장할 수 없습니다.")),
                                                              );
                                                            });
                                                          }
                                                        }(
                                                          widget.distance,
                                                          snapshot
                                                              .data!.capacity!
                                                              .toInt(),
                                                          snapshot.data!
                                                              .capacityCount!
                                                              .toInt(),
                                                        ),
                                                        icon: Icon(
                                                          size: 25,
                                                          isEntered
                                                              ? Icons
                                                                  .group_off_outlined
                                                              : Icons
                                                                  .input_outlined,
                                                          color: Colors.blue,
                                                        ),
                                                        label: Text(
                                                          isEntered
                                                              ? '퇴장하기'
                                                              : '입장하기',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 23,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          // 아래에서 반만 올라오는 내용을 표시하는 위젯
                                        );
                                      } else {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.open_in_new_outlined,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.001,
                ),
                Expanded(
                  child: NaverMap(
                    onMapReady: (NaverMapController controller) {
                      final marker = NMarker(
                        id: widget.shelterId.toString(),
                        position: NLatLng(widget.latitude, widget.longitude),
                      );
                      controller.addOverlay(marker);
                    },
                    options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                        target: NLatLng(
                          shelterData.latitude,
                          shelterData.longitude,
                        ),
                        zoom: 15,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
