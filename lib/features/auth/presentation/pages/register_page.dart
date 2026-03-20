import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/utils/toast_helper.dart';

class RegisterPage extends ConsumerStatefulWidget {
  static const path = '/register';
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreed = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tạo tài khoản mới',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                40.verticalSpace,
                TextFormField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại/email',
                    hintText: 'Nhập số điện thoại hoặc email',
                    prefixIcon: Icon(
                      IconsaxPlusLinear.user,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                ),
                16.verticalSpace,
                TextFormField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    hintText: 'Nhập mật khẩu',
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
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                ),
                16.verticalSpace,
                TextFormField(
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleRegister(),
                  decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu',
                    hintText: 'Nhập lại mật khẩu',
                    prefixIcon: Icon(
                      IconsaxPlusLinear.lock,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? IconsaxPlusLinear.eye_slash
                            : IconsaxPlusLinear.eye,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                ),
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreed,
                      onChanged: (value) {
                        setState(() {
                          _agreed = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _TermsText(
                          onOpenTerms: _openTermsOfUse,
                          onOpenPolicy: _openPrivacyPolicy,
                        ),
                      ),
                    ),
                  ],
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
                ElevatedButton(
                  onPressed: _handleRegister,
                  child: const Text('Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập đầy đủ thông tin';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Mật khẩu nhập lại không khớp';
      });
      return;
    }

    if (!_agreed) {
      setState(() {
        _errorMessage =
            'Vui lòng đồng ý với Quy định sử dụng và Chính sách bảo vệ dữ liệu cá nhân';
      });
      return;
    }

    if (_errorMessage.isNotEmpty) {
      setState(() {
        _errorMessage = '';
      });
    }

    ToastHelper.success(context, message: 'Đăng ký thành công (demo)');
  }

  void _openTermsOfUse() {
    ToastHelper.info(context, message: 'TODO: mở URL Quy định sử dụng');
  }

  void _openPrivacyPolicy() {
    ToastHelper.info(
      context,
      message: 'TODO: mở URL Chính sách bảo vệ dữ liệu cá nhân',
    );
  }
}

class _TermsText extends StatefulWidget {
  const _TermsText({required this.onOpenTerms, required this.onOpenPolicy});

  final VoidCallback onOpenTerms;
  final VoidCallback onOpenPolicy;

  @override
  State<_TermsText> createState() => _TermsTextState();
}

class _TermsTextState extends State<_TermsText> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _policyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = widget.onOpenTerms;
    _policyRecognizer = TapGestureRecognizer()..onTap = widget.onOpenPolicy;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _policyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(height: 1.35, color: Colors.grey[800]);

    final linkStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      height: 1.35,
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w600,
    );

    return Text.rich(
      TextSpan(
        style: normalStyle,
        children: [
          const TextSpan(text: 'Tôi đã đọc và đồng ý với '),
          TextSpan(
            text: 'Quy định sử dụng',
            style: linkStyle,
            recognizer: _termsRecognizer,
          ),
          const TextSpan(text: ' và '),
          TextSpan(
            text:
                'Chính sách bảo vệ dữ liệu cá nhân của Bệnh viện ĐKQT Hải Phòng',
            style: linkStyle,
            recognizer: _policyRecognizer,
          ),
          const TextSpan(
            text:
                ' và chấp thuận để bệnh viện xử lý dữ liệu cá nhân của tôi theo quy định của pháp luật về bảo vệ dữ liệu cá nhân.',
          ),
        ],
      ),
    );
  }
}
