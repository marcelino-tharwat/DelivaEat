# TODO: Localize Cart Page

## Tasks
- [ ] Add new localization keys to lib/l10n/intl_en.arb for cart page texts
- [ ] Add corresponding Arabic translations to lib/l10n/intl_ar.arb
- [ ] Update lib/features/cart/ui/add_to_cart.dart to import AppLocalizations and replace hard-coded strings
- [ ] Run flutter gen-l10n to regenerate localization files
- [ ] Test cart page in English and Arabic locales

## Details
- Keys to add: cartTitle, cartEmptyTitle, cartEmptySubtitle, startShopping, paymentSummary, subtotal, deliveryFee, serviceFee, totalAmount, checkout
- Ensure placeholders if needed (e.g., for prices)
