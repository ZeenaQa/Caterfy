import 'dart:math';

class VoucherOrder {
  final String id;
  final String customerId;
  final String provider;
  final String providerCategory;
  final String denominationLabel;
  final double priceJod;
  final String activationCode;
  final String status;
  final String? createdAt;

  const VoucherOrder({
    this.id = '',
    required this.customerId,
    required this.provider,
    required this.providerCategory,
    required this.denominationLabel,
    required this.priceJod,
    required this.activationCode,
    this.status = 'completed',
    this.createdAt,
  });

  /// Generates a random activation code matching [codeFormat].
  /// Every 'X' in the format is replaced with a random alphanumeric char.
  /// Example formats:
  ///   Xbox    → "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
  ///   PSN     → "XXXXX-XXXXX-XXXXX"
  ///   Steam   → "XXXXX-XXXXX-XXXXX"
  ///   Nintendo→ "XXXX-XXXX-XXXX-XXXX"
  ///   Roblox  → "XXXXXXXXXXXXXXXX"
  static String generateCode(String codeFormat) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rng = Random.secure();
    return codeFormat
        .split('')
        .map((c) => c == 'X' ? chars[rng.nextInt(chars.length)] : c)
        .join();
  }

  Map<String, dynamic> toMap() => {
        'customer_id': customerId,
        'provider': provider,
        'provider_category': providerCategory,
        'denomination_label': denominationLabel,
        'price_jod': priceJod,
        'activation_code': activationCode,
        'status': status,
      };

  factory VoucherOrder.fromMap(Map<String, dynamic> map) => VoucherOrder(
        id: map['id'] ?? '',
        customerId: map['customer_id'] ?? '',
        provider: map['provider'] ?? '',
        providerCategory: map['provider_category'] ?? '',
        denominationLabel: map['denomination_label'] ?? '',
        priceJod: (map['price_jod'] as num?)?.toDouble() ?? 0.0,
        activationCode: map['activation_code'] ?? '',
        status: map['status'] ?? 'completed',
        createdAt: map['created_at'],
      );
}
