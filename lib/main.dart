import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:threedotthree/pages/image_view_page.dart';

import 'models/image_item.dart';
import 'pages/main_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ImageItemAdapter());
  await Hive.openBox<ImageItem>('favorite');

  await dotenv.load(fileName: 'assets/config/.env');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '삼쩜삼',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      getPages: [
        GetPage(name: "/", page: () => const MainPage()),
        GetPage(name: MainPage.routeName, page: () => const MainPage()),
        GetPage(name: ImageViewPage.routeName, page: () => const ImageViewPage()),
      ],
      home: const MainPage(),
    );
  }
}
