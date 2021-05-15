import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_nus/settings/app_provider.dart';
import 'package:community_nus/screens/startAppLoadingScreen.dart';
import 'package:community_nus/settings/const.dart';
import 'settings/const.dart';

void main() {
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
