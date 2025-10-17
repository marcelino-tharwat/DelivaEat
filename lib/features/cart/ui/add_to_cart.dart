import 'package:deliva_eat/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:deliva_eat/features/cart/cubit/cart_cubit.dart';
import 'package:deliva_eat/features/cart/cubit/cart_state.dart';
import 'package:deliva_eat/features/cart/data/models/cart_response.dart';
import 'package:deliva_eat/features/restaurant/data/models/cart_models.dart' as models;
import 'widgets/cart_item_card.dart';
import 'widgets/payment_summary.dart';

// --- صفحة السلة ---
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _listKey = GlobalKey<SliverAnimatedListState>();
  final double deliveryFee = 9.00;
  final double serviceFeePercentage = 0.03;

  double _computeSubtotalFromBackend(CartData data) {
    // Sum (base food price + options) * quantity
    double total = 0;
    for (final it in data.items) {
      final base = (it.food?.price ?? 0).toDouble();
      final opts = it.options.fold<int>(0, (s, o) => s + (o.price)).toDouble();
      total += (base + opts) * (it.quantity);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading || state is CartInitial) {
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is CartError) {
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              centerTitle: true,
              title: Text(l10n.cartTitle),
            ),
            body: Center(child: Text(state.message)),
          );
        }
        final data = (state as CartLoaded).data;
        final items = data.items;
        if (items.isEmpty) {
          return _buildEmptyCart(theme, l10n);
        }

        // Map backend items to UI items using enriched food details
        final uiItems = items.map((e) => CartItem(
          id: e.id ?? e.foodId,
          name: (e.food?.name ?? e.food?.nameAr ?? 'Item') + '',
          image: (e.food?.image ?? 'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=400'),
          // show base food price only; addons shown below in summary of each item
          price: (e.food?.price ?? 0).toDouble(),
          quantity: e.quantity,
          addons: e.options.map((o) => AddonItem(
            id: o.code,
            name: o.code,
            image: 'https://images.unsplash.com/photo-1543357480-c60d40007a4e?w=200',
            price: o.price.toDouble(),
          )).toList(),
        )).toList();

        final subtotal = _computeSubtotalFromBackend(data);
        final serviceFee = subtotal * serviceFeePercentage;
        final totalAmount = subtotal + deliveryFee + serviceFee;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(theme, l10n),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                sliver: SliverAnimatedList(
                  key: _listKey,
                  initialItemCount: uiItems.length,
                  itemBuilder: (context, index, animation) {
                    final uiItem = uiItems[index];
                    final itemId = items[index].id; // keep original model id
                    return CartItemCard(
                      item: uiItem,
                      index: index,
                      onIncrement: (itemId == null)
                          ? null
                          : () => context.read<CartCubit>().incrementItem(
                                itemId,
                                uiItem.quantity,
                                lang: Localizations.localeOf(context).languageCode,
                              ),
                      onDecrement: (itemId == null || uiItem.quantity <= 1)
                          ? null
                          : () => context.read<CartCubit>().decrementItem(
                                itemId,
                                uiItem.quantity,
                                lang: Localizations.localeOf(context).languageCode,
                              ),
                      onRemoveAddon: null,
                      onRemoveItem: (itemId == null)
                          ? null
                          : () => context.read<CartCubit>().removeItem(
                                itemId,
                                lang: Localizations.localeOf(context).languageCode,
                              ),
                    );
                  },
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(children: [const Spacer(), PaymentSummary(
                  l10n: l10n,
                  subtotal: subtotal,
                  deliveryFee: deliveryFee,
                  serviceFee: serviceFee,
                  totalAmount: totalAmount,
                  onCheckout: uiItems.isEmpty
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(l10n.checkout),
                              content: Text(
                                '${l10n.total}: EGP ${totalAmount.toStringAsFixed(2)}',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(l10n.ok),
                                ),
                              ],
                            ),
                          );
                        },
                )]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRemovedCartItem(CartItem item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: CartItemCard(
          item: item,
          index: 0,
          isRemoving: true,
        ),
      ),
    );
  }

  Widget _buildEmptyCart(ThemeData theme, AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.cartTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              Text(l10n.cartEmptyTitle, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 10),
              Text(
                l10n.cartEmptySubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.startShopping),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(ThemeData theme, AppLocalizations l10n) {
    return SliverAppBar(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      pinned: false,
      floating: true,
      snap: true,
      centerTitle: true,
      leading: Center(
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.dividerColor),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
      title: Text(
        l10n.cartTitle,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
