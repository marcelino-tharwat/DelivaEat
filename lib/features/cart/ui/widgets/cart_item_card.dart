import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CartItem {
  final String id;
  final String name;
  final String image;
  final double price;
  int quantity;
  List<AddonItem> addons;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.addons = const [],
  });

  double get totalPrice {
    double addonsPricePerItem = addons.fold(
      0,
      (sum, addon) => sum + addon.price,
    );
    return (price + addonsPricePerItem) * quantity;
  }
}

class AddonItem {
  final String id;
  final String name;
  final String image;
  final double price;

  AddonItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });
}

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final int index;
  final bool isRemoving;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final Function(AddonItem)? onRemoveAddon;

  const CartItemCard({
    super.key,
    required this.item,
    required this.index,
    this.isRemoving = false,
    this.onIncrement,
    this.onDecrement,
    this.onRemoveAddon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: item.addons.isEmpty
                    ? const Radius.circular(12)
                    : Radius.zero,
                bottomRight: item.addons.isEmpty
                    ? const Radius.circular(12)
                    : Radius.zero,
              ),
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildMainItemInfo(context),
          ),
          if (item.addons.isNotEmpty) _buildAddonsSection(context),
        ],
      ),
    );
  }

  Widget _buildMainItemInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.image,
              width: 90,
              height: 80,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'EGP ${item.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          _buildQuantityControlButton(
                            context,
                            icon: Icons.remove,
                            onTap: isRemoving ? null : onDecrement,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Text(
                              '${item.quantity}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.normal),
                            ),
                          ),
                          _buildQuantityControlButton(
                            context,
                            icon: Icons.add,
                            onTap: isRemoving ? null : onIncrement,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControlButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap != null ? () => HapticFeedback.lightImpact() : null,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: 16,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildAddonsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Column(
          children: item.addons
              .map((addon) => _buildSingleAddonRow(context, addon))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSingleAddonRow(BuildContext context, AddonItem addon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              addon.image,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              addon.name,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            onPressed: () => onRemoveAddon?.call(addon),
            icon: Icon(
              Icons.close,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
