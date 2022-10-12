part of 'splash_screen.dart';

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({
    required this.onPressed,
    required this.error,
    Key? key,
  }) : super(key: key);
  final VoidCallback onPressed;
  final Object? error;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: context.allPadding(Sizes.medHigh),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _errorChildren(context),
          ),
        ),
      );

  List<Widget> _errorChildren(BuildContext context) => <Widget>[
        NotFittedText(error.toString(), maxLines: 4),
        context.sizedH(.8),
        const BaseText(SplashTexts.error),
        context.sizedH(3),
        ElevatedTextButton(
          onPressed: onPressed,
          text: SplashTexts.retry,
        ),
      ];
}
