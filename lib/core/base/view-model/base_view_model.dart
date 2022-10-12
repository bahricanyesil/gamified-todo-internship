import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../constants/enums/view-enums/view_states.dart';
import '../../helpers/completer_helper.dart';
import '../../managers/navigation/navigation_manager.dart';

/// Base view model class to create customized view models extending this.
abstract class BaseViewModel extends ChangeNotifier {
  /// Default constructor of [BaseViewModel].
  BaseViewModel() {
    _initCompleter = CompleterHelper.wrapCompleter<void>(_init());
  }

  ViewStates _viewState = ViewStates.uninitialized;

  /// Getter for [_viewState], shows the current state of the view.
  ViewStates get state => _viewState;

  /// Singleton navigation manager to use across the view models.
  final NavigationManager navigationManager = NavigationManager.instance;

  /// Custom init method to call before the initialization process is completed.
  FutureOr<void> init();

  /// Custom dipose method to call before the dispose.
  FutureOr<void> customDispose() {}

  late Completer<void> _initCompleter = Completer<void>();

  /// Completer to use for unawaited async function.
  late Completer<void> completer;

  /// Returns the init completer.
  Completer<void> get initCompleter => _initCompleter;

  @mustCallSuper
  @nonVirtual
  Future<void> _init() async {
    completer = Completer<void>();
    await init();
    if (_viewState == ViewStates.disposed) return;
    _viewState = ViewStates.loaded;
    reloadState();
  }

  /// Locally dispose the view and sets the [_viewState] property.
  @mustCallSuper
  @nonVirtual
  Future<void> disposeLocal() async {
    await customDispose();
    if (!completer.isCompleted) await completer.future;
    _viewState = ViewStates.disposed;
  }

  /// Reloads the state.
  void reloadState() {
    if (_viewState != ViewStates.loading && _viewState != ViewStates.disposed) {
      notifyListeners();
    }
  }

  /// Switches the loading status between
  /// [ViewStates.loaded] and [ViewStates.loading].
  void toggleLoadingStatus() {
    switch (_viewState) {
      case ViewStates.loading:
        _viewState = ViewStates.loaded;
        break;
      case ViewStates.loaded:
        _viewState = ViewStates.loading;
        break;
      default:
        break;
    }
    reloadState();
  }

  /// Returns whether the state is initialized.
  bool get isInitialized => state != ViewStates.uninitialized;
}
