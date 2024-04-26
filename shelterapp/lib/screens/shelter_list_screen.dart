import 'package:flutter/material.dart';

import 'package:shelterapp/models/shelter_model.dart';
import 'package:shelterapp/services/shelter_service.dart';

class ShelterListScreen extends StatefulWidget {
  final String? sidoName, sigunguName;
  const ShelterListScreen({
    super.key,
    required this.sidoName,
    required this.sigunguName,
  });

  @override
  State<ShelterListScreen> createState() => _ShelterListScreenState();
}

class _ShelterListScreenState extends State<ShelterListScreen> {
  late final Future<List<ShelterModel>> shelters;
  late final ShelterService service;
  @override
  void initState() {
    super.initState();
    shelters = ShelterService.getShelters(
      sidoName: widget.sidoName,
      sigunguName: widget.sigunguName,
    );
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
              "대피소 목록",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 1, 10, 100),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flex(
                        direction: Axis.vertical,
                        children: [
                          Text(
                            '거리',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
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
          ],
        ),
      ),
    );
  }

  ListView makeShelterList(AsyncSnapshot<List<ShelterModel>> snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        var shelter = snapshot.data![index];
        return ListTile(
          //leading
          title: Text(shelter.facilityName),
          subtitle: const Text("입장가능"),
          trailing: IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            onPressed: () {},
          ),
        );
      },
    );
  }
}
