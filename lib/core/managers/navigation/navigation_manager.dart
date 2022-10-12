import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'screen_config.dart';

/// Custom navigation manager.
class NavigationManager extends RouterDelegate<ScreenConfig>
    with
        // ignore: prefer_mixin
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<ScreenConfig> {
  /// Singleton navigation manager.
  factory NavigationManager() => _instance;
  NavigationManager._();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static final NavigationManager _instance = NavigationManager._();

  /// Returns the singleton instance of [NavigationManager].
  static NavigationManager get instance => _instance;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// The pages in the routing stack.
  final List<Page<dynamic>> _pages = <Page<dynamic>>[];

  @override
  ScreenConfig? get currentConfiguration =>
      _pages.last.arguments as ScreenConfig?;

  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey,
        onPopPage: _onPopPage,
        pages: List<Page<dynamic>>.of(_pages),
      );

  @override
  Future<void> setNewRoutePath(ScreenConfig configuration) async {
    _addPage(configuration);
    return SynchronousFuture<void>(null);
  }

  @override
  Future<void> setInitialRoutePath(ScreenConfig configuration) async {
    _addPage(configuration);
    return SynchronousFuture<void>(null);
  }

  /// Pops a page from the history.
  @override
  Future<bool> popRoute() async {
    if (_canPop) {
      _pages.removeLast();
      notifyListeners();
      return SynchronousFuture<bool>(true);
    }
    return SynchronousFuture<bool>(false);
  }

  /// Adds a new page to the current page path.
  void _addPage(ScreenConfig newScreen) {
    if (_canAdd(newScreen)) _addPageHelper(newScreen);
  }

  /// Replaces the last page with the given new one.
  void replacePage(ScreenConfig newScreen) {
    if (_canAdd(newScreen)) {
      _pages.removeLast();
      _addPageHelper(newScreen);
    }
  }

  void _addPageHelper(ScreenConfig newScreen) {
    if (_pages.length > 1 && _pages[_pages.length - 2].name == newScreen.path) {
      _pages.removeLast();
      return;
    }
    _pages.add(
      MaterialPage<dynamic>(
        child: newScreen.builder(),
        key: UniqueKey(),
        name: newScreen.path,
        arguments: newScreen,
      ),
    );
    notifyListeners();
  }

  /// Removes the given screen.
  void removePage(ScreenConfig screen) {
    final int index =
        _pages.indexWhere((Page<dynamic> e) => e.name == screen.path);
    if (index == -1) return;
    _pages.removeAt(index);
    notifyListeners();
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    final bool didPop = route.didPop(result);
    if (!didPop) return false;
    _pages.remove(route.settings);
    notifyListeners();
    return true;
  }

  /// Removes the pages until the specified page.
  /// Returns [bool] to indicate whether can be popped or not.
  bool popUntil(ScreenConfig untilScreen) {
    final int pageIndex = _pages
        .indexWhere((Page<dynamic> screen) => screen.name == untilScreen.path);
    if (_pages.isEmpty || pageIndex == -1) return false;
    _pages.removeRange(pageIndex + 1, _pages.length);
    notifyListeners();
    return true;
  }

  /// Removes all pages until there is left one (initial) page.
  void popUntilOneLeft() {
    if (!_canPop) return;
    _pages.removeRange(1, _pages.length);
    notifyListeners();
  }

  bool get _canPop => _pages.length > 1;

  bool _canAdd(ScreenConfig newScreen) {
    if (_pages.isEmpty) return true;
    return (_pages.last.arguments as ScreenConfig?)?.path != newScreen.path;
  }
}
