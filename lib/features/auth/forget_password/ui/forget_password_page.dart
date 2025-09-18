// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:deliva_eat/core/widgets/app_button.dart';
// import 'package:deliva_eat/core/widgets/app_text_field.dart';
// import 'package:deliva_eat/l10n/app_localizations.dart';

// class ForgotPasswordPage extends StatelessWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ForgotPasswordCubit(),
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         backgroundColor: const Color(0xFFF9F9F9),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
//               listener: (context, state) {
//                 if (state is ForgotPasswordFailure) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(state.errorMessage),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//                 if (state is ForgotPasswordSuccess) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Reset link sent to your email"),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                   // Navigate back to login or to verification screen
//                   Navigator.pop(context);
//                 }
//               },
//               builder: (context, state) {
//                 return Column(
//                   children: [
//                     const ForgotPasswordHeader(),
//                     Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const ForgotPasswordForm(),
//                           SizedBox(height: 30.h),
//                           _buildBackToLoginButton(context),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBackToLoginButton(BuildContext context) {
//     return TextButton(
//       onPressed: () => Navigator.pop(context),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.arrow_back_ios, color: Colors.yellow[700], size: 16),
//           const SizedBox(width: 4),
//           Text(
//             'Back to Login',
//             style: TextStyle(
//               color: Colors.yellow[700],
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ForgotPasswordHeader extends StatelessWidget {
//   const ForgotPasswordHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: DelivaEatClipper(),
//       child: Container(
//         height: 250.h,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.yellow[600]!,
//               Colors.yellow[700]!,
//               Colors.yellow[600]!,
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.lock_reset, size: 60, color: Colors.white),
//               SizedBox(height: 16),
//               Text(
//                 'Forgot Password?',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: 1,
//                   shadows: [
//                     Shadow(
//                       offset: Offset(2, 2),
//                       blurRadius: 4,
//                       color: Colors.black26,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Reset your password easily',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white70,
//                   letterSpacing: 1,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DelivaEatClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(0, 0);
//     path.lineTo(0, size.height - 60);
//     final firstControlPoint = Offset(size.width * 0.25, size.height);
//     final firstEndPoint = Offset(size.width * 0.5, size.height - 30);
//     path.quadraticBezierTo(
//       firstControlPoint.dx,
//       firstControlPoint.dy,
//       firstEndPoint.dx,
//       firstEndPoint.dy,
//     );
//     final secondControlPoint = Offset(size.width * 0.75, size.height - 60);
//     final secondEndPoint = Offset(size.width, size.height - 20);
//     path.quadraticBezierTo(
//       secondControlPoint.dx,
//       secondControlPoint.dy,
//       secondEndPoint.dx,
//       secondEndPoint.dy,
//     );
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

// // forgot_password_form.dart

// class ForgotPasswordForm extends StatefulWidget {
//   const ForgotPasswordForm({super.key});

//   @override
//   State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
// }

// class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   void _resetPassword() {
//     if (_formKey.currentState!.validate()) {
//       context.read<ForgotPasswordCubit>().resetPassword(
//         email: _emailController.text,
//         context: context,
//       );
//     }
//   }

//   bool _isEmailValid(String email) {
//     return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;

//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           Text(
//             'Reset Password',
//             style: TextStyle(
//               fontSize: 28.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[800],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Enter your email address and we\'ll send you a reset link',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16.sp,
//               color: Colors.grey[600],
//               height: 1.4,
//             ),
//           ),
//           SizedBox(height: 40.h),

//           // Email Field
//           AppTextField(
//             controller: _emailController,
//             labelText: l10n.email,
//             hintText: 'example@gmail.com',
//             prefixIcon: Icons.email_outlined,
//             keyboardType: TextInputType.emailAddress,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return l10n.error_email_required;
//               }
//               if (!_isEmailValid(value)) {
//                 return 'Please enter a valid email address';
//               }
//               return null;
//             },
//           ),
//           SizedBox(height: 30.h),

//           // Reset Button
//           SizedBox(
//             width: double.infinity,
//             height: 50.h,
//             child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
//               builder: (context, state) {
//                 final loading = state is ForgotPasswordLoading;
//                 return AbsorbPointer(
//                   absorbing: loading,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Opacity(
//                         opacity: loading ? 0.6 : 1,
//                         child: AppButton(
//                           text: 'Send Reset Link',
//                           onPressed: _resetPassword,
//                         ),
//                       ),
//                       if (loading)
//                         const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.white,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 20.h),

//           // Info Text
//           Container(
//             padding: EdgeInsets.all(16.w),
//             decoration: BoxDecoration(
//               color: Colors.blue[50],
//               borderRadius: BorderRadius.circular(12.r),
//               border: Border.all(color: Colors.blue[200]!),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.info_outline, color: Colors.blue[600], size: 20.sp),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Text(
//                     'Check your email inbox and spam folder for the reset link',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: Colors.blue[700],
//                       height: 1.3,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
//   ForgotPasswordCubit() : super(ForgotPasswordInitial());

//   Future<void> resetPassword({
//     required String email,
//     required BuildContext context,
//   }) async {
//     try {
//       emit(ForgotPasswordLoading());

//       // Simulate API call
//       await Future.delayed(const Duration(seconds: 2));

//       // TODO: Implement actual forgot password API call
//       // final result = await _authRepository.resetPassword(email);

//       // For now, simulate success
//       emit(ForgotPasswordSuccess());
//     } catch (e) {
//       emit(ForgotPasswordFailure(e.toString()));
//     }
//   }
// }

// // forgot_password_state.dart
// // part of 'forgot_password_cubit.dart';

// @immutable
// sealed class ForgotPasswordState {}

// final class ForgotPasswordInitial extends ForgotPasswordState {}

// final class ForgotPasswordLoading extends ForgotPasswordState {}

// final class ForgotPasswordSuccess extends ForgotPasswordState {}

// final class ForgotPasswordFailure extends ForgotPasswordState {
//   final String errorMessage;

//   ForgotPasswordFailure(this.errorMessage);
// }
import 'package:deliva_eat/features/auth/forget_password/cubit/forgot_password_cubit.dart';
import 'package:deliva_eat/features/auth/forget_password/cubit/forgot_password_state.dart';
import 'package:deliva_eat/features/auth/forget_password/ui/widgets/forgot_password.form.dart';
import 'package:deliva_eat/features/auth/forget_password/ui/widgets/forgot_password_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart'; // Assuming you use get_it for DI

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (state is ForgotPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.forgotPasswordSuccessResponse.data!["message"],
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate back to login after showing success message
                Future.delayed(const Duration(seconds: 2), () {
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                });
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  const ForgotPasswordHeader(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ForgotPasswordForm(),
                        SizedBox(height: 30.h),
                        _buildBackToLoginButton(context),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios, color: Colors.yellow[700], size: 16),
          const SizedBox(width: 4),
          Text(
            'Back to Login',
            style: TextStyle(
              color: Colors.yellow[700],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
