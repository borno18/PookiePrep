import 'package:flutter/material.dart';

/// Comfortable reading widths and system insets for every feature screen.
class PookieScaffold extends StatelessWidget {
  const PookieScaffold(
      {super.key, this.appBar, required this.body, this.bottomNavigationBar});

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar,
        body: SafeArea(
          top: appBar == null,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 840), child: body),
          ),
        ),
        bottomNavigationBar: bottomNavigationBar == null
            ? null
            : SafeArea(
                top: false,
                child: bottomNavigationBar!,
              ),
      );
}
