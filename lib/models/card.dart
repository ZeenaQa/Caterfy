class Card {
  final String id;
  final String customerID;
  final String cardNumber;
  final int expMonth;
  final int expYear;
  final String brand;

  Card({
    required this.id,
    required this.customerID,
    required this.cardNumber,
    required this.expMonth,
    required this.expYear,
    required this.brand,
  });

  // FROM SUPABASE (Map → Card)
  factory Card.fromMap(Map<String, dynamic> map) {
    return Card(
      id: map['id'],
      customerID: map['customer_id'],
      cardNumber: map['card_number'],
      expMonth: map['exp_month'],
      expYear: map['exp_year'],
      brand: map['brand'],
    );
  }

  // TO SUPABASE (Card → Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerID,
      'card_number': cardNumber,
      'exp_month': expMonth,
      'exp_year': expYear,
      'brand': brand,
    };
  }
}
