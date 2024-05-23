import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelterapp/provider/user_provider.dart';
import 'package:shelterapp/screens/search_screen.dart';
import 'package:shelterapp/screens/userInfo_screen.dart';

class Root extends StatefulWidget {
  final int selectedIndex;
  const Root({super.key, required this.selectedIndex});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;
  UserController? userState;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    userState = Provider.of<UserController>(context, listen: false);

    setState(() {
      userState!.fetchUserData();
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const SearchScreen(),
    const UserInfoScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _selectedIndex == 0 ? "검색" : "내 정보",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
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
}
