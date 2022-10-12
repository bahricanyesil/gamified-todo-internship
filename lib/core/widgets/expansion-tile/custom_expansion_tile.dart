import 'package:flutter/material.dart';

import '../../constants/border/border_radii.dart';
import '../../constants/durations/durations.dart';
import '../../extensions/color/color_extensions.dart';
import '../../extensions/context/responsiveness_extensions.dart';

/// Customized version of official expansion tile.
class CustomExpansionTile extends StatefulWidget {
  /// Default constructor for [CustomExpansionTile].
  const CustomExpansionTile({
    required this.mainListTile,
    this.title,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.leading,
    this.subtitle,
    this.trailing,
    this.children = const <Widget>[],
    this.childrenPadding,
    this.expandedAlignment,
    this.tilePadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.collapsedIconColor,
    this.collapsedTextColor,
    this.expandedCrossAxisAlignment,
    this.iconColor,
    this.textColor,
    this.borderRadius,
    this.leadingText,
    this.leadingColor,
    this.customChildrenWidget,
    Key? key,
  }) : super(key: key);

  /// Determines whether the tile is initially expanded.
  final bool initiallyExpanded;

  /// Callback to call on expansion changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// A widget to display before the title.
  final Widget? leading;

  /// The primary content of the list item.
  final Widget? title;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// A widget to display after the title.
  final Widget? trailing;

  /// Specifies padding for the [ListTile].
  final EdgeInsetsGeometry? tilePadding;

  /// Specifies the alignment of [children], which are arranged in a
  /// column when the tile is expanded. When the value is null,
  /// the value of `expandedAlignment` is [Alignment.center].
  final Alignment? expandedAlignment;

  /// Specifies padding for [children]. When the value is null,
  /// the value of `childrenPadding` is [EdgeInsets.zero].
  final EdgeInsetsGeometry? childrenPadding;

  /// The widgets that are displayed when the tile expands.
  final List<Widget> children;

  /// Specifies the alignment of each child within [children] when the
  /// tile is expanded. When the value is null, the value of
  /// `expandedCrossAxisAlignment` is [CrossAxisAlignment.center].
  final CrossAxisAlignment? expandedCrossAxisAlignment;

  /// The icon color of tile's expansion arrow icon when the sublist is
  /// expanded. Used to override to the [ListTileThemeData.iconColor].
  final Color? iconColor;

  /// The icon color of tile's expansion arrow icon when the sublist is
  /// collapsed. Used to override to the [ListTileThemeData.iconColor].
  final Color? collapsedIconColor;

  /// The color of the tile's titles when the sublist is expanded.
  /// Used to override to the [ListTileThemeData.textColor].
  final Color? textColor;

  /// The color of the tile's titles when the sublist is collapsed.
  /// Used to override to the [ListTileThemeData.textColor].
  final Color? collapsedTextColor;

  /// The color to display behind the sublist when expanded.
  final Color? backgroundColor;

  /// When not null, defines the background color of tile when the sublist
  /// is collapsed.
  final Color? collapsedBackgroundColor;

  /// Custom border radius.
  final BorderRadius? borderRadius;

  /// Leading text for the default widget.
  final String? leadingText;

  /// Leading color for the default widget.
  final Color? leadingColor;

  /// Main widget in the expansion tile.
  final Widget mainListTile;

  /// Custom complete children widget.
  final Widget? customChildrenWidget;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  // static final Animatable<double> _halfTween =
  //     Tween<double>(begin: 0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  // late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _borderColorAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  late bool _isExpanded = widget.initiallyExpanded;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Durations.fast, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    // _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColorAnimation =
        _controller.drive(_borderColorTween.chain(_easeOutTween));
    // _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    // _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColorAnimation =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));
    _isExpanded = PageStorage.of(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (mounted) setState(() {});
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween
      ..begin = widget.backgroundColor
      ..end = widget.backgroundColor?.darken(.1);
    _headerColorTween
      ..begin = widget.collapsedTextColor ?? theme.textTheme.subtitle1!.color
      ..end = widget.textColor ?? colorScheme.primary;
    _iconColorTween
      ..begin = widget.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = widget.iconColor ?? colorScheme.primary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor
      ..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : _child(closed),
    );
  }

  Widget _child(bool closed) => Offstage(
        offstage: closed,
        child: TickerMode(
          enabled: !closed,
          child: widget.customChildrenWidget ??
              Column(
                crossAxisAlignment: widget.expandedCrossAxisAlignment ??
                    CrossAxisAlignment.start,
                children: widget.children,
              ),
        ),
      );

  Widget _buildChildren(BuildContext context, Widget? child) => InkWell(
        onTap: _handleTap,
        highlightColor: widget.backgroundColor,
        splashColor: widget.backgroundColor,
        customBorder: RoundedRectangleBorder(
            borderRadius: _borderRadius, side: BorderSide(color: _borderColor)),
        borderRadius: widget.borderRadius ?? BorderRadii.mediumCircular,
        child: Container(
          decoration: _boxDeco,
          padding: _padding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[widget.mainListTile, _childInColumn(child)],
          ),
        ),
      );

  Widget _childInColumn(Widget? child) => ClipRect(
        child: Align(
          alignment: widget.expandedAlignment ?? Alignment.centerLeft,
          heightFactor: _heightFactor.value,
          child: child,
        ),
      );

  EdgeInsetsGeometry _padding(BuildContext context) =>
      widget.childrenPadding ??
      EdgeInsets.symmetric(
        vertical: context.responsiveSize,
        horizontal: context.responsiveSize * 3,
      );

  BoxDecoration get _boxDeco => BoxDecoration(
        color: _backgroundColor,
        border: Border.all(color: _borderColor),
        borderRadius: _borderRadius,
      );

  Color get _backgroundColor =>
      _backgroundColorAnimation.value ?? Colors.transparent;

  BorderRadius get _borderRadius =>
      widget.borderRadius ?? BorderRadii.mediumCircular;

  Color get _borderColor => _borderColorAnimation.value ?? Colors.transparent;
}
