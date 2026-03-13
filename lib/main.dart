import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthcare_app/core/config/env_config.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/widgets/app_loading.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/providers/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.init();
  await initializeDateFormatting('vi_VN', null);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final authState = ref.watch(authProvider);

    return authState.maybeWhen(
      checking: () => MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
        locale: const Locale('vi', 'VN'),
        home: Scaffold(body: Center(child: AppLoading())),
      ),
      orElse: () => MaterialApp.router(
        title: 'Health',
        theme: AppTheme.lightTheme,
        routerConfig: router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
        locale: const Locale('vi', 'VN'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
