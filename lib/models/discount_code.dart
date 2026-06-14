class DiscountCode {
  final String id;
  final String code;
  final String discountType; // 'percentage' | 'fixed'
  final double discountValue;
  final double minOrderAmount;
  final int? maxUses;
  final int usesCount;
  final DateTime? expiresAt;
  final bool isActive;
  final String? storeId;

  const DiscountCode({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    this.minOrderAmount = 0,
    this.maxUses,
    this.usesCount = 0,
    this.expiresAt,
    this.isActive = true,
    this.storeId,
  });

  bool get isPercentage => discountType == 'percentage';

  double computeDiscount(double subtotal) {
    if (isPercentage) {
      return subtotal * (discountValue / 100);
    }
    return discountValue;
  }

  factory DiscountCode.fromMap(Map<String, dynamic> map) {
    return DiscountCode(
      id: map['id'] as String,
      code: map['code'] as String,
      discountType: map['discount_type'] as String,
      discountValue: (map['discount_value'] as num).toDouble(),
      minOrderAmount: (map['min_order_amount'] as num?)?.toDouble() ?? 0,
      maxUses: map['max_uses'] as int?,
      usesCount: (map['uses_count'] as num?)?.toInt() ?? 0,
      expiresAt: map['expires_at'] != null
          ? DateTime.parse(map['expires_at'] as String)
          : null,
      isActive: map['is_active'] as bool? ?? true,
      storeId: map['store_id'] as String?,
    );
  }
}
