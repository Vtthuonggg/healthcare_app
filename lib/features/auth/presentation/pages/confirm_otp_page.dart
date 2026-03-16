import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/toast_helper.dart';
import 'dart:async';

class ConfirmOtpPage extends ConsumerStatefulWidget {
  static const path = '/confirm-otp';
  const ConfirmOtpPage({super.key, required this.username});

  final String username;

  @override
  ConsumerState<ConfirmOtpPage> createState() => _ConfirmOtpPageState();
}

class _ConfirmOtpPageState extends ConsumerState<ConfirmOtpPage> {
  static const _otpLength = 6;
  static const _initialCountdownSeconds = 100;

  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  Timer? _countdownTimer;
  int _secondsRemaining = _initialCountdownSeconds;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _otpFocusNode.requestFocus();
    });
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    final username = widget.username.trim();
    final otp = _otpController.text;
    final canConfirm = otp.length == _otpLength;
    final canResend = _secondsRemaining == 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Xác thực số điện thoại/email',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                24.verticalSpace,
                Text(
                  'Mã xác thực OTP đã được gửi đến số điện thoại/email sau',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    height: 1.35,
                  ),
                  textAlign: TextAlign.left,
                ),
                8.verticalSpace,
                Text(
                  username.isEmpty ? '-' : username,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                24.verticalSpace,

                GestureDetector(
                  onTap: () => _otpFocusNode.requestFocus(),
                  behavior: HitTestBehavior.opaque,
                  child: Center(child: _OtpBoxes(controller: _otpController)),
                ),

                Offstage(
                  offstage: true,
                  child: TextField(
                    controller: _otpController,
                    focusNode: _otpFocusNode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(_otpLength),
                    ],
                    onChanged: (_) {
                      if (!mounted) return;
                      if (_errorMessage.isNotEmpty) {
                        setState(() => _errorMessage = '');
                      } else {
                        setState(() {});
                      }
                    },
                    onSubmitted: (_) => _handleConfirm(),
                  ),
                ),

                if (_errorMessage.isNotEmpty) ...[
                  12.verticalSpace,
                  Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],

                28.verticalSpace,
                ElevatedButton(
                  onPressed: canConfirm ? _handleConfirm : null,
                  child: const Text('Xác nhận'),
                ),
                12.verticalSpace,
                TextButton(
                  onPressed: canResend ? _handleResend : null,
                  child: Text(
                    canResend
                        ? 'Gửi lại OTP'
                        : 'Gửi lại OTP (${_secondsRemaining}s)',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _secondsRemaining = _initialCountdownSeconds;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
        });
        return;
      }
      setState(() {
        _secondsRemaining -= 1;
      });
    });
  }

  void _handleConfirm() {
    final otp = _otpController.text;
    if (otp.length != _otpLength) {
      setState(() {
        _errorMessage = 'Vui lòng nhập đủ $_otpLength chữ số OTP';
      });
      return;
    }

    TextInput.finishAutofillContext();
    ToastHelper.success(context, message: 'Xác thực OTP thành công (demo)');
  }

  void _handleResend() {
    ToastHelper.info(context, message: 'Đã gửi lại OTP (demo)');
    _otpController.clear();
    _otpFocusNode.requestFocus();
    _startCountdown();
  }
}

class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final text = controller.text;
        final activeIndex = text.length.clamp(
          0,
          _ConfirmOtpPageState._otpLength - 1,
        );

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_ConfirmOtpPageState._otpLength, (index) {
            final digit = index < text.length ? text[index] : '';
            final isActive =
                text.length < _ConfirmOtpPageState._otpLength &&
                index == activeIndex;

            return Container(
              width: 44.w,
              height: 50.h,
              margin: EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isActive
                      ? theme.colorScheme.primary
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Text(
                digit,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
