import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'common/routers/index.dart';
import 'global.dart';

Future<void> main() async {
  await Global.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'GetMaterialApp 示例',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: RoutePages.inital,
          getPages: RoutePages.list,
          navigatorObservers: [RoutePages.observer],
          debugShowCheckedModeBanner: false,
          // translations: TranslationService(),
        );
      },
    );
  }
}
