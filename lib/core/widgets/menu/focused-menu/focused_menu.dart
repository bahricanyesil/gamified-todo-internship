import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../constants/border/border_radii.dart';
import '../../../constants/durations/durations.dart';
import '../../../extensions/color/color_extensions.dart';
import '../../../extensions/context/responsiveness_extensions.dart';
import '../../../theme/color/l_colors.dart';
import '../../list/default_list_view_builder.dart';

part 'focused_menu_details.dart';
part 'focused_menu_item_model.dart';

/// Customized focused menu.
/// Implemented according to the implementation of:
/// https://pub.dev/packages/focused_menu
class FocusedMenu extends StatefulWidget {
  /// Default constructor of [FocusedMenu].
  const FocusedMenu({
    required this.child,
    required this.onPressed,
    required this.menuItems,
    this.duration,
    this.menuBoxDecoration,
    this.menuItemExtent,
    this.animateMenuItems,
    this.blurSize,
    this.blurBackgroundColor,
    this.menuWidth,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.openWithTap = false,
    this.scrollPhysics,
    this.highlightColor,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  /// Child of the focused menu.
  final Widget child;

  /// Extent of the menu items.
  final double? menuItemExtent;

  /// Width of the menu.
  final double? menuWidth;

  /// Menu items list.
  final List<FocusedMenuItem> menuItems;

  /// Determines whether to animate menu items.
  final bool? animateMenuItems;

  /// Decoration of the menu.
  final BoxDecoration? menuBoxDecoration;

  /// Callback to call on pressed.
  final VoidCallback onPressed;

  /// Custom duration for animation.
  final Duration? duration;

  /// Size of the blur.
  final double? blurSize;

  /// Custom background color of the blur.
  final Color? blurBackgroundColor;

  /// Offset from the bottom.
  final double? bottomOffsetHeight;

  /// Menu offset.
  final double? menuOffset;

  /// Determines whether to open with tap.
  final bool openWithTap;

  /// Custom scroll physics.
  final ScrollPhysics? scrollPhysics;

  /// Highlight color.
  final Color? highlightColor;

  /// Radius of the border.
  final BorderRadius? borderRadius;

  @override
  _FocusedMenuState createState() => _FocusedMenuState();
}

class _FocusedMenuState extends State<FocusedMenu> {
  final GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset.zero;
  late Size childSize = Size.fromHeight(context.height * 5);

  @override
  Widget build(BuildContext context) => InkWell(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) await openMenu(context);
        },
        onLongPress: () async {
          if (!widget.openWithTap) await openMenu(context);
        },
        splashFactory: InkRipple.splashFactory,
        highlightColor: widget.highlightColor ?? Colors.transparent,
        borderRadius: widget.borderRadius ?? BorderRadii.lowCircular,
        child: widget.child,
      );

  /// Opens the menu.
  Future<void> openMenu(BuildContext context) async {
    _setOffset();
    await Navigator.push(
      context,
      PageRouteBuilder<FadeTransition>(
        transitionDuration: widget.duration ?? Durations.tooFast,
        pageBuilder: _pageBuilder,
        fullscreenDialog: true,
        opaque: false,
      ),
    );
  }

  Widget _pageBuilder(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(animation),
        child: _FocusedMenuDetails(
          itemExtent: widget.menuItemExtent,
          menuBoxDecoration: widget.menuBoxDecoration,
          childOffset: childOffset,
          childSize: childSize,
          menuItems: widget.menuItems,
          blurSize: widget.blurSize,
          menuWidth: widget.menuWidth,
          blurBackgroundColor: widget.blurBackgroundColor,
          animateMenu: widget.animateMenuItems ?? true,
          bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
          menuOffset: widget.menuOffset ?? 0,
          scrollingPhysics: widget.scrollPhysics,
          child: widget.child,
        ),
      );

  void _setOffset() {
    final RenderBox? renderBox =
        containerKey.currentContext?.findRenderObject() as RenderBox?;
    final Offset? offset = renderBox?.localToGlobal(Offset.zero);
    if (offset == null && renderBox == null) return;
    setState(() {
      if (offset != null) childOffset = Offset(offset.dx, offset.dy);
      if (renderBox != null) childSize = renderBox.size;
    });
  }
}
