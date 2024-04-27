import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  final ScrollController _scrollController = ScrollController();
  late final Future<List<ShelterModel>> shelters;
  late final ShelterService service;
  bool _isVisible = false;

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 750), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    shelters = ShelterService.getShelters(
      sidoName: widget.sidoName,
      sigunguName: widget.sigunguName,
    );

    _scrollController.addListener(() {
      setState(() {
        _isVisible = _scrollController.offset >= 700;
      });
    });
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
    );
  }

  ListView makeShelterList(AsyncSnapshot<List<ShelterModel>> snapshot) {
    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        var shelter = snapshot.data![index];
        return ListTile(
          //leading
          title: Row(
            children: [
              const Text("10km"),
              const SizedBox(
                width: 40,
              ),
              Flexible(
                child: Text(
                  shelter.facilityName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("입장가능"),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            onPressed: () {},
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 2,
        );
      },
    );
  }
}
