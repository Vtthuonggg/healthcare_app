import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/providers/auth_state.dart';
import '../../features/main/presentation/pages/main_page.dart';
import 'transition_helper.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  return GoRouter(
    initialLocation: LoginPage.path,
    redirect: (context, state) {
      return authState.maybeWhen(
        authenticated: (_) {
          if (state.matchedLocation == LoginPage.path) {
            return MainPage.path;
          }
          return null;
        },
        unauthenticated: () {
          if (state.matchedLocation != LoginPage.path) {
            return LoginPage.path;
          }
          return null;
        },
        orElse: () => null,
      );
    },
    routes: [
      GoRoute(
        path: LoginPage.path,
        pageBuilder: (context, state) =>
            TransitionHelper.fade(state, const LoginPage()),
      ),
      GoRoute(
        path: MainPage.path,
        pageBuilder: (context, state) =>
            TransitionHelper.fade(state, MainPage()),
      ),
    ],
  );
});
