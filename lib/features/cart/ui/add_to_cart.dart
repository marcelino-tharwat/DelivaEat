import 'package:deliva_eat/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
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

  List<CartItem> cartItems = [
    CartItem(
      id: '1',
      name: 'Chicken Schezwan Fried Rice',
      image:
          'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=400',
      price: 30.0,
      quantity: 1,
      addons: [
        AddonItem(
          id: 'addon1',
          name: 'Add extra chicken ( EGP +10 )',
          image:
              'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=200',
          price: 10.0,
        ),
        AddonItem(
          id: 'addon2',
          name: 'Add CoCa Cola ( EGP +15 )',
          image:
              'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=200',
          price: 15.0,
        ),
      ],
    ),
    CartItem(
      id: '2',
      name: 'Special Veg Pizza',
      image:
          'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=400',
      price: 45.0,
      quantity: 2,
      addons: [],
    ),
  ];

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  double get serviceFee => subtotal * serviceFeePercentage;
  double get totalAmount => subtotal + deliveryFee + serviceFee;

  void incrementQuantity(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void decrementQuantity(int index) {
    HapticFeedback.lightImpact();
    if (cartItems[index].quantity > 1) {
      setState(() {
        cartItems[index].quantity--;
      });
    } else {
      final removedItem = cartItems.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildRemovedCartItem(removedItem, animation),
        duration: const Duration(milliseconds: 300),
      );
      setState(() {});
    }
  }

  void removeAddon(CartItem item, AddonItem addonToRemove) {
    setState(() {
      item.addons.remove(addonToRemove);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (cartItems.isEmpty) {
      return _buildEmptyCart(theme, l10n);
    }
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(theme, l10n),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            sliver: SliverAnimatedList(
              key: _listKey,
              initialItemCount: cartItems.length,
              itemBuilder: (context, index, animation) =>
                  CartItemCard(
                    item: cartItems[index],
                    index: index,
                    onIncrement: () => incrementQuantity(index),
                    onDecrement: () => decrementQuantity(index),
                    onRemoveAddon: (addon) => removeAddon(cartItems[index], addon),
                  ),
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
              onCheckout: cartItems.isEmpty
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
