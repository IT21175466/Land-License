import 'package:flutter/material.dart';
import 'package:land_license/Add_License_Page.dart';
import 'package:land_license/Home_Page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:land_license/Search_License.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
        routes: {
          '/addLicensePage': (_) => const AddLicense(),
          '/home': (_) => const HomePage(),
          '/searchLicense': (_) => const SearchLicense(),
        },
      ),
      designSize: Size(360, 640),
      useInheritedMediaQuery: true,
      minTextAdapt: true,
    );
  }
}
