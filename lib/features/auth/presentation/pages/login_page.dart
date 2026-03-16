import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare_app/features/auth/presentation/pages/forget_password_page.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/utils/asset_helper.dart';
import 'register_page.dart';
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
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.maybeWhen(
        error: (message) {
          if (!mounted) return;
          setState(() {
            _errorMessage = message;
          });
          log(message);
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Optional: bo góc
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: FadeInImage(
                      placeholder: AssetImage(AssetHelper.placeholder),
                      image: AssetImage(AssetHelper.logo),
                      fit: BoxFit.contain,
                      imageErrorBuilder: (context, error, stackTrace) {
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
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Text.rich(
                    TextSpan(
                      text: 'BỆNH VIỆN ĐA KHOA QUỐC TẾ\n',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                      children: [
                        TextSpan(
                          text: 'HẢI PHÒNG',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
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
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).nextFocus();
                    },
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại/email',
                      hintText: 'Nhập tài khoản của bạn',

                      prefixIcon: Icon(
                        IconsaxPlusLinear.user,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      _handleLogin();
                    },
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
                  ),
                  if (_errorMessage.isNotEmpty) ...[
                    8.verticalSpace,
                    Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                  24.verticalSpace,
                  authState.maybeWhen(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    orElse: () => ElevatedButton(
                      onPressed: _handleLogin,
                      child: const Text('Đăng nhập'),
                    ),
                  ),
                  14.verticalSpace,
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.push(ForgetPasswordPage.path);
                      },
                      child: const Text('Quên mật khẩu?'),
                    ),
                  ),
                  12.verticalSpace,

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Bạn chưa có tài khoản?'),
                        TextButton(
                          onPressed: () {
                            context.push(RegisterPage.path);
                          },
                          child: const Text('Đăng ký ngay'),
                        ),
                      ],
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
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập đầy đủ thông tin';
      });
      return;
    }

    if (_errorMessage.isNotEmpty) {
      setState(() {
        _errorMessage = '';
      });
    }

    ref
        .read(authProvider.notifier)
        .login(_usernameController.text, _passwordController.text);
  }
}
