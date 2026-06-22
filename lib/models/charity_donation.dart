import 'dart:math';

class CharityDonation {
  final String id;
  final String customerId;
  final String orgName;
  final String orgCategory;
  final double amountJod;
  final String reference;
  final String? createdAt;

  const CharityDonation({
    this.id = '',
    required this.customerId,
    required this.orgName,
    required this.orgCategory,
    required this.amountJod,
    required this.reference,
    this.createdAt,
  });

  static String generateRef() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    return 'DON-${List.generate(8, (_) => chars[rng.nextInt(chars.length)]).join()}';
  }

  Map<String, dynamic> toMap() => {
        'customer_id': customerId,
        'org_name': orgName,
        'org_category': orgCategory,
        'amount_jod': amountJod,
        'reference': reference,
      };

  factory CharityDonation.fromMap(Map<String, dynamic> map) => CharityDonation(
        id: map['id'] ?? '',
        customerId: map['customer_id'] ?? '',
        orgName: map['org_name'] ?? '',
        orgCategory: map['org_category'] ?? '',
        amountJod: (map['amount_jod'] as num?)?.toDouble() ?? 0.0,
        reference: map['reference'] ?? '',
        createdAt: map['created_at'],
      );
}
