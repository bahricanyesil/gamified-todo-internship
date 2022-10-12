import 'package:flutter/material.dart';

import '../../../core/extensions/color/color_extensions.dart';
import '../../../core/theme/color/l_colors.dart';

/// Colors to use in dark theme.
class DarkColors extends IColors {
  /// Color configurations for dark mode.
  DarkColors()
      : super(
          colorScheme: ColorScheme.fromSwatch(
            primaryColorDark: _primaryDark,
            backgroundColor: AppColors.darkGrey.darken(),
            errorColor: AppColors.error,
            cardColor: _primaryColor,
            accentColor: _accentColor,
            primarySwatch: const MaterialColor(_primary, _swatch),
          ),
          appBarColor: _primaryColor,
          scaffoldBackgroundColor: AppColors.darkGrey.darken(),
          brightness: Brightness.dark,
          disabledColor: _primaryDark,
          dividerColor: _primaryColor,
          highlightColor: _primaryLight,
          primaryColorDark: _primaryDark,
          primaryColorLight: _primaryLight,
          tabBarColor: _primaryColor,
          tabbarNormalColor: _primaryColor,
          tabbarSelectedColor: _primaryLight,
        );

  static const int _primary = 0xff668cff;
  static const Color _primaryColor = Color(_primary);
  static const Color _accentColor = Color(0xffffa866);

  static const Map<int, Color> _swatch = <int, Color>{
    50: Color.fromRGBO(4, 131, 184, .1),
    100: Color.fromRGBO(4, 131, 184, .2),
    200: Color.fromRGBO(4, 131, 184, .3),
    300: Color.fromRGBO(4, 131, 184, .4),
    400: Color.fromRGBO(4, 131, 184, .5),
    500: Color.fromRGBO(4, 131, 184, .6),
    600: Color.fromRGBO(4, 131, 184, .7),
    700: Color.fromRGBO(4, 131, 184, .8),
    800: Color.fromRGBO(4, 131, 184, .9),
    900: Color.fromRGBO(4, 131, 184, 1),
  };

  static const Color _primaryLight = Color(0xff668cff);
  static const Color _primaryDark = Color(0xff668aff);
}
