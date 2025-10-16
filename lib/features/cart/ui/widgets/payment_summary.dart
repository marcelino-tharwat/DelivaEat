import 'package:deliva_eat/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class PaymentSummary extends StatelessWidget {
  final AppLocalizations l10n;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double totalAmount;
  final VoidCallback? onCheckout;

  const PaymentSummary({
    super.key,
    required this.l10n,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.totalAmount,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.paymentSummary,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(context, l10n.subtotal, 'EGP ${subtotal.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _buildSummaryRow(
              context,
              l10n.deliveryFee(deliveryFee.toStringAsFixed(0)),
              'EGP ${deliveryFee.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              context,
              l10n.serviceFee,
              'EGP ${serviceFee.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: theme.dividerColor),
            const SizedBox(height: 16),
            _buildSummaryRow(
              context,
              l10n.totalAmount,
              'EGP ${totalAmount.toStringAsFixed(2)}',
              isBold: true,
            ),
            const SizedBox(height: 20),
            AppButton(
              text: l10n.checkout,
              onPressed: onCheckout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value, {bool isBold = false}) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
