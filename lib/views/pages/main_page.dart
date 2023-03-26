import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:threedotthree/views/image_search_list_view.dart';

import '../../controllers/favorite_controller.dart';
import '../../controllers/image_controller.dart';
import '../favorite_list_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const routeName = '/MainPage';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);

    Get.put(ImageController());
    Get.put(FavoriteController());

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildTabBar() {
    return Container(
      height: 48,
      alignment: Alignment.center,
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF407BFF),
        unselectedLabelColor: const Color(0xFF979797),
        indicatorWeight: 0.1,
        indicatorColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontSize: 13,
          color: Color(0xFF307BFF),
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          color: Color(0xFF979797),
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(icon: Icon(CupertinoIcons.list_bullet)),
          Tab(icon: Icon(CupertinoIcons.star_fill)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    ImageSearchListView(),
                    FavoriteListView(),
                  ],
                ),
              ),
            ),
            buildTabBar(),
            SizedBox(height: Platform.isIOS ? 36 : 0),
          ],
        ),
      ),
    );
  }
}
