import 'package:flutter/material.dart';
import '../data/mock_coupons.dart';
import '../models/coupon.dart';

class PromoController extends ChangeNotifier {
  final ValueNotifier<Coupon?> appliedCoupon = ValueNotifier<Coupon?>(null);
  final ValueNotifier<String?> lastError = ValueNotifier<String?>(null);

  List<Coupon> get coupons => mockCoupons;

  double discountFor(double subtotal) {
    final coupon = appliedCoupon.value;
    if (coupon == null) return 0;
    return coupon.discountAmount(subtotal);
  }

  bool apply(Coupon coupon, double subtotal) {
    final errorKey = _validate(coupon, subtotal);
    lastError.value = errorKey;
    if (errorKey != null) return false;
    appliedCoupon.value = coupon;
    notifyListeners();
    return true;
  }

  bool applyCode(String code, double subtotal) {
    final coupon = coupons.firstWhere(
      (c) => c.code.toLowerCase() == code.toLowerCase(),
      orElse: () => const Coupon(
        code: '',
        titleEn: '',
        titleAr: '',
        descriptionEn: '',
        descriptionAr: '',
        discountPercent: 0,
        minSpend: 0,
        expiresAt: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );
    if (coupon.code.isEmpty) {
      lastError.value = 'invalid_coupon';
      return false;
    }
    return apply(coupon, subtotal);
  }

  String? _validate(Coupon coupon, double subtotal) {
    if (coupon.isExpired) return 'expired_coupon';
    if (subtotal < coupon.minSpend) return 'min_spend_coupon';
    return null;
  }

  void clear() {
    appliedCoupon.value = null;
    lastError.value = null;
    notifyListeners();
  }

  @override
  void dispose() {
    appliedCoupon.dispose();
    lastError.dispose();
    super.dispose();
  }
}
