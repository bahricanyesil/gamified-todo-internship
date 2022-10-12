import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/managers/navigation/navigation_manager.dart';
import 'core/managers/navigation/screen_config.dart';
import 'core/providers/provider_list.dart';
import 'initial_web_app.dart' if (dart.library.io) 'initial_app.dart';
import 'product/managers/local-storage/settings/settings_local_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NavigationManager.instance
      .setInitialRoutePath(ScreenConfig.defaultScreen());
  await Hive.initFlutter();
  await SettingsLocalManager.instance.initStorage();
  runApp(const _BeforeApp());
}

class _BeforeApp extends StatefulWidget {
  const _BeforeApp({Key? key}) : super(key: key);

  @override
  State<_BeforeApp> createState() => _BeforeAppState();
}

class _BeforeAppState extends State<_BeforeApp> {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: ProviderList.providers,
        child: const InitialApp(appName: 'Gamified To-Do'),
      );
}
