import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:deliva_eat/features/cart/cubit/cart_cubit.dart';
import 'package:deliva_eat/features/cart/cubit/cart_state.dart';
import 'package:deliva_eat/core/widgets/app_button.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkout),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartError) {
            return Center(child: Text(state.message));
          }
          if (state is CartLoaded) {
            // For now, just show a placeholder
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.checkout),
                  const SizedBox(height: 20),
                  AppButton(
                    onPressed: () {
                      // Implement checkout logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Checkout not implemented yet')),
                      );
                    },
                    text: l10n.checkout,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
