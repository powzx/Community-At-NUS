import 'package:community_nus/Settings_BackEndDataBase/app_provider.dart';
import 'package:community_nus/Settings_BackEndDataBase/Constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/BaseScreen_Feature/StartAppLoadingScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          darkTheme: Constants.darkTheme,
          home: startAppLoadingScreen(),
        );
      },
    );
  }
}
