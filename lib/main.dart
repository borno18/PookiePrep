import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme.dart';
import 'data/repository/pookie_repository.dart';
import 'features/navigation/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = PookieRepository();
  await repository.init();
  runApp(PookiePrepApp(repository: repository));
}

class PookiePrepApp extends StatelessWidget {
  const PookiePrepApp({super.key, required this.repository});

  final PookieRepository repository;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repository,
      builder: (context, _) {
        return MaterialApp(
          title: 'পুকি প্রেপ',
          debugShowCheckedModeBanner: false,
          theme: buildPookieTheme(),
          locale: const Locale('bn'),
          supportedLocales: const [Locale('bn')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: MainScaffold(repository: repository),
        );
      },
    );
  }
}
