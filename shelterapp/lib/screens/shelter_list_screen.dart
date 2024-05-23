import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:shelterapp/models/shelter_model.dart';
import 'package:shelterapp/provider/user_provider.dart';
import 'package:shelterapp/screens/root.dart';
import 'package:shelterapp/screens/shelter_map_screen.dart';
import 'package:shelterapp/services/shelter_service.dart';

class ShelterListScreen extends StatefulWidget {
  final String? sidoName, sigunguName;
  final double? latitude, longitude;

  const ShelterListScreen(
      {super.key,
      required this.sidoName,
      required this.sigunguName,
      this.latitude,
      this.longitude});

  @override
  State<ShelterListScreen> createState() => _ShelterListScreenState();
}

class _ShelterListScreenState extends State<ShelterListScreen> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<ShelterModel>> shelters;
  late final double distance;
  bool _isVisible = false;
  final int _selectedIndex = 0;
  UserController? userState;

// 대피소와 현재 위치 사이의 거리를 계산하는 함수
  double calculateDistance(double shelterLatitude, double shelterLongitude,
      double currentLatitude, double currentLongitude) {
    var currentLng = NLatLng(currentLatitude, currentLongitude);
    var shelterLng = NLatLng(shelterLatitude, shelterLongitude);
    double distance = currentLng.distanceTo(shelterLng);
    return distance;
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 50), curve: Curves.decelerate);
  }

  @override
  void initState() {
    super.initState();
    fetchShelters();
    _scrollController.addListener(() {
      setState(() {
        _isVisible = _scrollController.offset >= 200;
      });
    });
  }

  void fetchShelters() {
    shelters = ShelterService.getShelters(
      sidoName: widget.sidoName,
      sigunguName: widget.sigunguName,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

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
              "대피소 목록",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 20,
                    bottom: 20,
                    right: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '거리',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '시설명',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '길찾기',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
            ),
            FutureBuilder(
              future: shelters,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Expanded(child: makeShelterList(snapshot));
                } else {
                  return Text('Error: ${snapshot.error}');
                }
              },
            ),
            Visibility(
              visible: _isVisible,
              child: Transform.translate(
                offset: const Offset(10, -30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        _scrollToTop();
                      },
                      color: Colors.grey,
                      splashColor: Colors.black,
                      padding: const EdgeInsets.all(8),
                      shape: const CircleBorder(),
                      child: const Text(
                        "TOP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(
            () {
              switch (value) {
                case 0:
                  Navigator.pop(context, 0);

                  break;
                case 1:
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Root(selectedIndex: value),
                    ),
                    (route) => false, // 모든 이전 경로를 제거하기 위해 false 반환
                  );
                  break;
              }
            },
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.grey, // 선택된 상태의 아이콘 색상
            ),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
            ),
            label: "mypage",
          ),
        ],
      ),
    );
  }

  ListView makeShelterList(AsyncSnapshot<List<ShelterModel>> snapshot) {
    // 거리에 따라 대피소 목록을 정렬
    List<ShelterModel> sortedShelters = snapshot.data!;
    double currentLatitude = widget.latitude!;
    double currentLongitude = widget.longitude!;

// 만약 longitude가 음수라면 한국의 일정한 좌표로 대체
    if (widget.longitude! < 0) {
      currentLatitude = 37.0113;
      currentLongitude = 127.2653;
      sortedShelters.sort((a, b) {
        double distanceA = calculateDistance(
            a.latitude, a.longitude, currentLatitude, currentLongitude);
        double distanceB = calculateDistance(
            b.latitude, b.longitude, currentLatitude, currentLongitude);

        return distanceA.compareTo(distanceB);
      });
    } else {
      sortedShelters.sort((a, b) {
        double distanceA = calculateDistance(
            a.latitude, a.longitude, widget.latitude!, widget.longitude!);
        double distanceB = calculateDistance(
            b.latitude, b.longitude, widget.latitude!, widget.longitude!);
        return distanceA.compareTo(distanceB);
      });
    }

    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        var shelter = snapshot.data![index];
        double distance = calculateDistance(shelter.latitude, shelter.longitude,
            currentLatitude, currentLongitude);

        return ListTile(
          //leading
          title: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.13,
                child: Text(
                  distance < 1000
                      ? '${distance.toInt()} m'
                      : '${(distance / 1000).toStringAsFixed(1)} km',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Expanded(
                child: Text(
                  shelter.facilityName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              shelter.capacity! > shelter.capacityCount!
                  ? const Text("입장가능")
                  : const Text("수용불가"),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShelterMapScreen(
                    shelterId: shelter.shelterId,
                    latitude: shelter.latitude,
                    longitude: shelter.longitude,
                    distance: distance,
                    sidoName: widget.sidoName,
                    sigunguName: widget.sigunguName,
                  ),
                ),
              ).then(
                (needRefresh) {
                  if (needRefresh == true) {
                    setState(
                      () {
                        fetchShelters();
                      },
                    );
                  }
                },
              );
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: MediaQuery.of(context).size.height * 0.01,
        );
      },
    );
  }
}
