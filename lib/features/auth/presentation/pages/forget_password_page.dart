import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare_app/features/auth/presentation/pages/confirm_otp_page.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ForgetPasswordPage extends ConsumerStatefulWidget {
  static const path = '/forget-password';
  const ForgetPasswordPage({super.key});

  @override
  ConsumerState<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends ConsumerState<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Quên mật khẩu',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
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
                  onPressed: _handleContinue,
                  child: const Text('Tiếp tục'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_usernameController.text.isNotEmpty) {
      context.push(ConfirmOtpPage.path, extra: _usernameController.text);
    } else {
      setState(() {
        _errorMessage = 'Vui lòng nhập thông tin hợp lệ';
      });
    }
  }
}
