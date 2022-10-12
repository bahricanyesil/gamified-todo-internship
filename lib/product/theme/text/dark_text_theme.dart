import '../../../core/theme/color/l_colors.dart';
import '../../../core/theme/text/l_text_theme.dart';

/// Text themes to use in the dark mode.
class DarkTextTheme extends ITextTheme {
  /// Default [DarkTextTheme] constructor.
  const DarkTextTheme()
      : super(
          primaryTextColor: AppColors.white,
          secondaryTextColor: AppColors.white,
        );
}
