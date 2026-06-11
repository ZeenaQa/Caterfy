import 'dart:math';

class TicketOrder {
  final String id;
  final String customerId;
  final String eventName;
  final String eventCategory;
  final String ticketType;
  final String eventDate;
  final String venue;
  final double priceJod;
  final String bookingRef;
  final int quantity;
  final String status;
  final String? createdAt;

  const TicketOrder({
    this.id = '',
    required this.customerId,
    required this.eventName,
    required this.eventCategory,
    required this.ticketType,
    required this.eventDate,
    required this.venue,
    required this.priceJod,
    required this.bookingRef,
    this.quantity = 1,
    this.status = 'confirmed',
    this.createdAt,
  });

  static String generateBookingRef() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rng = Random.secure();
    final code = List.generate(8, (_) => chars[rng.nextInt(chars.length)]).join();
    return 'TKT-$code';
  }

  Map<String, dynamic> toMap() => {
        'customer_id': customerId,
        'event_name': eventName,
        'event_category': eventCategory,
        'ticket_type': ticketType,
        'event_date': eventDate,
        'venue': venue,
        'price_jod': priceJod,
        'booking_ref': bookingRef,
        'quantity': quantity,
        'status': status,
      };

  factory TicketOrder.fromMap(Map<String, dynamic> map) => TicketOrder(
        id: map['id'] ?? '',
        customerId: map['customer_id'] ?? '',
        eventName: map['event_name'] ?? '',
        eventCategory: map['event_category'] ?? '',
        ticketType: map['ticket_type'] ?? '',
        eventDate: map['event_date'] ?? '',
        venue: map['venue'] ?? '',
        priceJod: (map['price_jod'] as num?)?.toDouble() ?? 0.0,
        bookingRef: map['booking_ref'] ?? '',
        quantity: (map['quantity'] as num?)?.toInt() ?? 1,
        status: map['status'] ?? 'confirmed',
        createdAt: map['created_at'],
      );
}
