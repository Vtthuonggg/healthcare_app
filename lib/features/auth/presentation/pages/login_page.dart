import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/asset_helper.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const path = '/login';
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (user) {
          context.go(MainPage.path);
        },
        error: (message) {
          ToastHelper.error(context, message: message);
        },
        orElse: () {},
      );
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Image.asset(
                    AssetHelper.logo,
                    fit: BoxFit.cover,
                    scale: 0.5,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(
                          IconsaxPlusLinear.building_4,
                          size: 60,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Đăng nhập',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nhập tài khoản và mật khẩu',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Tài khoản',
                      hintText: 'Nhập tài khoản của bạn',
                      prefixIcon: Icon(
                        IconsaxPlusLinear.user,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được bỏ trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),

                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      hintText: 'Nhập mật khẩu của bạn',
                      prefixIcon: Icon(
                        IconsaxPlusLinear.lock,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? IconsaxPlusLinear.eye_slash
                              : IconsaxPlusLinear.eye,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mật khẩu không được để trống';
                      }
                      if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  authState.maybeWhen(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    orElse: () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _handleLogin,
                      child: const Text('Đăng nhập'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authProvider.notifier)
          .login(_usernameController.text, _passwordController.text);
    }
  }
}
