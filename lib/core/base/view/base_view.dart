import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/enums/view-enums/view_states.dart';
import '../../extensions/context/responsiveness_extensions.dart';
import '../../helpers/selector_helper.dart';
import '../../widgets/widgets_shelf.dart';
import '../view-model/base_view_model.dart';

/// Base view class to create customized view models using this.
class BaseView<T extends BaseViewModel> extends StatefulWidget {
  /// Default constructor for [BaseView].
  const BaseView({
    required this.bodyBuilder,
    this.customDispose,
    this.customInitState,
    this.appBar,
    this.resizeToAvoidBottomInset = true,
    this.safeArea = true,
    Key? key,
  }) : super(key: key);

  /// Function to build the body.
  final Widget Function(BuildContext) bodyBuilder;

  /// Custom dispose method to call on dispose.
  final VoidCallback? customDispose;

  /// Custom init state method to call on init state.
  final void Function(T model)? customInitState;

  /// Custom app bar.
  final DefaultAppBar? appBar;

  /// Determines whether to resize to avoid bottom inset in [Scaffold].
  final bool resizeToAvoidBottomInset;

  /// Determines whether to wrap with [SafeArea].
  final bool safeArea;

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  late T model = context.read<T>();
  bool _customInitialized = false;

  @override
  void dispose() {
    model.disposeLocal();
    if (widget.customDispose != null) widget.customDispose!();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model = context.read<T>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        appBar: _appBar,
        body: widget.safeArea ? SafeArea(child: _child) : _child,
      ),
    );
  }

  DefaultAppBar? get _appBar =>
      widget.appBar?.copyWithSize(context.height * 6.8);

  Widget get _child => SelectorHelper<ViewStates, T>().builder(
        (BuildContext context, T localModel) => localModel.state,
        _selectorBuilder,
      );

  Widget _selectorBuilder(BuildContext context, ViewStates val, _) {
    if (val == ViewStates.uninitialized) {
      return const Center(child: LoadingIndicator());
    }
    if (widget.customInitState != null && !_customInitialized) {
      widget.customInitState!(model);
      _customInitialized = true;
    }
    return widget.bodyBuilder(context);
  }
}
