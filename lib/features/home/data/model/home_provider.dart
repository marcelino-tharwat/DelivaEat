import 'package:deliva_eat/features/home/data/model/category_model.dart';
import 'package:deliva_eat/features/home/data/model/offer_model.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HomeDataProvider {
  static List<Offer> getOffers(AppLocalizations l10n) {
    return [
      Offer(
        title: l10n.offerTodayTitle,
        subtitle: l10n.offerTodaySubtitle,
        color: const Color(0xFFFF6B35),
        icon: '🍔',
        image: 'assets/offer_burger.png',
        discount: '29',
      ),
      Offer(
        title: l10n.offerFreeDeliveryTitle,
        subtitle: l10n.offerFreeDeliverySubtitle,
        color: const Color(0xFFFF6B35),
        icon: '🚚',
        image: 'assets/offer_delivery.png',
        discount: l10n.offerFreeDiscount,
      ),
      Offer(
        title: l10n.offerPizzaTitle,
        subtitle: l10n.offerPizzaSubtitle,
        color: const Color(0xFFFF6B35),
        icon: '🍕',
        image: 'assets/offer_pizza.png',
        discount: '50',
      ),
    ];
  }

  static List<Category> getCategories(AppLocalizations l10n) {
    return [
      Category(
        name: l10n.categoryFood,
        icon: Icons.restaurant_menu,
        color: const Color(0xFFFF9800),
        gradient: [const Color(0xFFFF9800), const Color(0xFFFFCC02)],
      ),
      Category(
        name: l10n.categoryGrocery,
        icon: Icons.local_grocery_store,
        color: const Color(0xFFFF9800),
        gradient: [const Color(0xFFFF9800), const Color(0xFFFFCC02)],
      ),
      // ... أضف باقي الفئات بنفس الطريقة
    ];
  }
}
