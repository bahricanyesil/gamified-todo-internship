import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/enums/view-enums/sizes.dart';
import '../../../core/extensions/context/responsiveness_extensions.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../home/view/home_screen.dart';
import '../../settings/view-model/settings_view_model.dart';
import '../constants/splash_texts.dart';
import '../view-model/splash_view_model.dart';

part './error_splash_screen.dart';

/// Splash screen of the app.
class SplashScreen extends StatefulWidget {
  /// Default constructor for splash screen.
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SplashTexts {
  late Future<bool> _initialize;
  bool _retrying = false;
  late SplashViewModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<SplashViewModel>();
    _initialize = _initializeApp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model = context.read<SplashViewModel>();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<bool>(future: _initialize, builder: _builder);

  Widget _builder(BuildContext context, AsyncSnapshot<bool> snapshot) {
    if (snapshot.hasData && !_retrying) {
      return const HomeScreen();
    } else if (snapshot.hasError && !_retrying) {
      return _ErrorScreen(error: snapshot.error, onPressed: _onRetry);
    }
    return const LoadingIndicator();
  }

  void _onRetry() {
    _initialize = _retryInitialization();
    setState(() => _retrying = true);
  }

  Future<bool> _initializeApp() async {
    final SettingsViewModel settingsModel = context.read<SettingsViewModel>();
    if (!model.isInitialized) await model.initCompleter.future;
    await model.initSettings(settingsModel);
    await model.initStorage();
    return false;
  }

  Future<bool> _retryInitialization() async {
    final bool res = await _initializeApp();
    setState(() => _retrying = false);
    return res;
  }
}
