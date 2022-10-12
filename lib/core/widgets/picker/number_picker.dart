import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_listview/infinite_listview.dart';

import '../../constants/durations/durations.dart';
import '../../decoration/text_styles.dart';
import '../../extensions/context/responsiveness_extensions.dart';
import '../../extensions/context/theme_extensions.dart';
import '../list/default_list_view_builder.dart';
import '../text/base_text.dart';

/// Text mapper function definion.
typedef TextMapper = String Function(String numberText);

/// Implemented according to the implemenation of:
/// https://pub.dev/packages/numberpicker
class NumberPicker extends StatefulWidget {
  /// Default constructor of [NumberPicker].
  const NumberPicker({
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
    this.itemCount = 3,
    this.step = 1,
    this.itemHeightFactor,
    this.itemWidthFactor,
    this.axis = Axis.vertical,
    this.textStyle,
    this.selectedTextStyle,
    this.haptics = false,
    this.decoration,
    this.zeroPad = false,
    this.textMapper,
    this.infiniteLoop = false,
    Key? key,
  })  : assert(minValue <= value, 'Value cannot be less than minValue'),
        assert(value <= maxValue, 'Value cannot be greater than maxValue'),
        super(key: key);

  /// Min value user can pick
  final int minValue;

  /// Max value user can pick
  final int maxValue;

  /// Currently selected value
  final int value;

  /// Called when selected value changes
  final ValueChanged<int> onChanged;

  /// Specifies how many items should be shown - defaults to 3
  final int itemCount;

  /// Step between elements. Only for integer datePicker
  /// Examples:
  /// if step is 100 the following elements may be 100, 200, 300...
  /// if min=0, max=6, step=3, then items will be 0, 3 and 6
  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  /// height of single item in pixels
  final double? itemHeightFactor;

  /// width of single item in pixels
  final double? itemWidthFactor;

  /// Direction of scrolling
  final Axis axis;

  /// Style of non-selected numbers. If null, it uses Theme's bodyText2
  final TextStyle? textStyle;

  /// Style of non-selected numbers.
  final TextStyle? selectedTextStyle;

  /// Whether to trigger haptic pulses or not
  final bool haptics;

  /// Build the text of each item on the picker
  final TextMapper? textMapper;

  /// Pads displayed integer values up to the length of maxValue
  final bool zeroPad;

  /// Decoration to apply to central box where the selected value is placed
  final Decoration? decoration;

  /// Determines whether the loop is infinite.
  final bool infiniteLoop;

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.infiniteLoop ? InfiniteScrollController() : ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final double initialOffset =
          (widget.value - widget.minValue) ~/ widget.step * itemExtent;
      _scrollController.jumpTo(initialOffset);
    });
  }

  void _scrollListener() {
    int indexOfMiddleElement = (_scrollController.offset / itemExtent).round();
    if (widget.infiniteLoop) {
      indexOfMiddleElement %= itemCount;
    } else {
      indexOfMiddleElement = indexOfMiddleElement.clamp(0, itemCount - 1);
    }
    final int intValueInTheMiddle =
        _intValueFromIndex(indexOfMiddleElement + additionalItemsOnEachSide);

    if (widget.value != intValueInTheMiddle) {
      widget.onChanged(intValueInTheMiddle);
      if (widget.haptics) HapticFeedback.selectionClick();
    }
    Future<void>.delayed(Durations.tooFast, _maybeCenterValue);
  }

  @override
  void didUpdateWidget(NumberPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _maybeCenterValue();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: _width,
        height: _height,
        child: NotificationListener<ScrollEndNotification>(
            onNotification: _scrollNotification, child: _stack),
      );

  Widget get _stack => Stack(
        children: <Widget>[
          if (widget.infiniteLoop) _infiniteLoop else _normalLoop,
          _NumberPickerSelectedItemDecoration(
            axis: widget.axis,
            itemExtent: itemExtent,
            decoration: widget.decoration,
          ),
        ],
      );

  bool _scrollNotification(ScrollEndNotification not) {
    if (not.dragDetails?.primaryVelocity == 0) {
      Future<void>.microtask(_maybeCenterValue);
    }
    return true;
  }

  Widget get _infiniteLoop => InfiniteListView.builder(
        scrollDirection: widget.axis,
        controller: _scrollController as InfiniteScrollController,
        itemExtent: itemExtent,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: _itemBuilder,
        padding: EdgeInsets.zero,
      );

  Widget get _normalLoop => DefaultListViewBuilder(
        itemCount: listItemsCount,
        scrollDirection: widget.axis,
        controller: _scrollController,
        itemExtent: itemExtent,
        itemBuilder: _itemBuilder,
      );

  double get _width => widget.axis == Axis.vertical
      ? context.width * itemWidthFactor
      : context.width * widget.itemCount * itemWidthFactor;

  double get _height => widget.axis == Axis.vertical
      ? context.height * widget.itemCount * itemHeightFactor
      : context.height * itemHeightFactor;

  Widget _itemBuilder(BuildContext context, int index) {
    final TextStyle defaultStyle =
        widget.textStyle ?? TextStyles(context).subBodyStyle();
    final TextStyle selectedStyle = widget.selectedTextStyle ??
        TextStyles(context).titleStyle(
            color: context.primaryColor, wordSpacing: 1, fontSizeFactor: 6.8);

    final int value = _intValueFromIndex(index % itemCount);
    final bool isExtra = !widget.infiniteLoop &&
        (index < additionalItemsOnEachSide ||
            index >= listItemsCount - additionalItemsOnEachSide);
    final TextStyle itemStyle =
        value == widget.value ? selectedStyle : defaultStyle;

    final Widget child = isExtra
        ? const SizedBox.shrink()
        : BaseText(_getDisplayedValue(value), style: itemStyle);

    return Container(
      width: context.width * itemWidthFactor,
      height: context.height * itemHeightFactor,
      alignment: Alignment.center,
      child: child,
    );
  }

  String _getDisplayedValue(int value) {
    final String text = widget.zeroPad
        ? value.toString().padLeft(widget.maxValue.toString().length, '0')
        : value.toString();
    if (widget.textMapper != null) {
      return widget.textMapper!(text);
    } else {
      return text;
    }
  }

  int _intValueFromIndex(int i) {
    int index = i - additionalItemsOnEachSide;
    index %= itemCount;
    return widget.minValue + index * widget.step;
  }

  void _maybeCenterValue() {
    if (_scrollController.hasClients && !isScrolling) {
      final int diff = widget.value - widget.minValue;
      int index = diff ~/ widget.step;
      if (widget.infiniteLoop) {
        final double offset = _scrollController.offset + 0.5 * itemExtent;
        final int cycles = (offset / (itemCount * itemExtent)).floor();
        index += cycles * itemCount;
      }
      _scrollController.animateTo(
        index * itemExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  double get itemHeightFactor => widget.itemHeightFactor ?? 5;
  double get itemWidthFactor => widget.itemWidthFactor ?? 30;

  bool get isScrolling => _scrollController.position.isScrollingNotifier.value;

  double get itemExtent => widget.axis == Axis.vertical
      ? context.height * itemHeightFactor
      : context.width * itemWidthFactor;

  int get itemCount => (widget.maxValue - widget.minValue) ~/ widget.step + 1;

  int get listItemsCount => itemCount + 2 * additionalItemsOnEachSide;

  int get additionalItemsOnEachSide => (widget.itemCount - 1) ~/ 2;
}

class _NumberPickerSelectedItemDecoration extends StatelessWidget {
  const _NumberPickerSelectedItemDecoration({
    required this.axis,
    required this.itemExtent,
    required this.decoration,
    Key? key,
  }) : super(key: key);

  final Axis axis;
  final double itemExtent;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) => Center(
        child: IgnorePointer(
          child: Container(
            width: isVertical ? double.infinity : itemExtent,
            height: isVertical ? itemExtent : double.infinity,
            decoration: decoration,
          ),
        ),
      );

  bool get isVertical => axis == Axis.vertical;
}
