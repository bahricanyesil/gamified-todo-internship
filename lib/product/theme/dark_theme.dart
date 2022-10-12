import '../../core/theme/l_theme.dart';
import 'color/dark_colors.dart';
import 'text/dark_text_theme.dart';

/// Dark theme of the app.
class DarkTheme extends ITheme {
  /// Default constructor for [DarkTheme].
  DarkTheme()
      : super(
          colors: DarkColors(),
          textTheme: const DarkTextTheme(),
        );
}
