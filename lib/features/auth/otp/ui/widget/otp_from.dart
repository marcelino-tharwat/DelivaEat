import 'dart:async';
import 'package:deliva_eat/features/auth/otp/cubit/otp_cubit.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpForm extends StatefulWidget {
  final String email;

  const OtpForm({super.key, required this.email});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _remainingTime = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _remainingTime = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      String OTP = context.read<OtpCubit>().otp;
      context.read<OtpCubit>().otp = _controllers.map((c) => c.text).join();
      if (OTP.length == 6) {
        context.read<OtpCubit>().verifyOtp(
          otp: OTP,
          email: widget.email,
          context: context,
        );
      }
    }
  }

  void _resendOtp() {
    if (_canResend) {
      context.read<OtpCubit>().resendOtp(email: widget.email, context: context);
      _startTimer();
    }
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.enter_verification_code,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                height: 1.4,
              ),
              children: [
                TextSpan(text: AppLocalizations.of(context)!.sent_code_to),
                TextSpan(
                  text: widget.email,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),

          // OTP Input Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 45.w,
                height: 55.h,
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.grey[50],

                    // 🟡 ثبّت عرض الـ border في كل الحالات
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: Colors.yellow[600]!,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: Colors.red.shade300,
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: Colors.red.shade400,
                        width: 1.5,
                      ),
                    ),
                    errorStyle: const TextStyle(height: 0),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => _onChanged(value, index),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? '' : null,
                ),
              );
            }),
          ),
          SizedBox(height: 30.h),

          // Verify Button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: BlocBuilder<OtpCubit, OtpState>(
              builder: (context, state) {
                final isLoading = state is OtpLoading;
                return ElevatedButton(
                  onPressed: isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.verify_code,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),

          // Resend Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.didnt_receive_code,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              TextButton(
                onPressed: _canResend ? _resendOtp : null,
                child: Text(
                  _canResend
                      ? AppLocalizations.of(context)!.resend
                      : AppLocalizations.of(
                          context,
                        )!.resend_in(_remainingTime.toString()),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: _canResend ? Colors.yellow[700] : Colors.grey[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
