import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/managers/navigation/navigation_shelf.dart';
import 'core/providers/theme/theme_provider.dart';

/// Material app widget of the app.
class InitialApp extends StatelessWidget {
  /// Default constructor for [InitialApp] widget.
  const InitialApp({required this.appName, Key? key}) : super(key: key);

  /// Name of the app.
  final String appName;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: context.watch<ThemeProvider>().currentTheme,
        routerDelegate: NavigationManager(),
        backButtonDispatcher: RootBackButtonDispatcher(),
        routeInformationParser: CustomRouteInfoParser(),
      );
}
