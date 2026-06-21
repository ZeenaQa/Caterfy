class LaundryOrder {
  final String id;
  final String customerId;
  final String storeName;
  final String storeImageUrl;
  final String service;
  final String address;
  final String phone;
  final String pickupTime;
  final String deliveryDate;
  final String? status;
  final String? createdAt;

  const LaundryOrder({
    this.id = '',
    required this.customerId,
    this.storeName = 'Laundry Service',
    this.storeImageUrl = '',
    required this.service,
    required this.address,
    required this.phone,
    required this.pickupTime,
    required this.deliveryDate,
    this.status,
    this.createdAt,
  });

  bool get isDelivered => status?.toLowerCase() == 'delivered';
  bool get isActive => !isDelivered;

  LaundryOrder copyWith({String? status}) => LaundryOrder(
        id: id,
        customerId: customerId,
        storeName: storeName,
        storeImageUrl: storeImageUrl,
        service: service,
        address: address,
        phone: phone,
        pickupTime: pickupTime,
        deliveryDate: deliveryDate,
        status: status ?? this.status,
        createdAt: createdAt,
      );

  Map<String, dynamic> toMap() => {
        'customer_id': customerId,
        'store_name': storeName,
        'store_image_url': storeImageUrl,
        'service': service,
        'address': address,
        'phone': phone,
        'pickup_time': pickupTime,
        'delivery_date': deliveryDate,
        'status': status ?? 'scheduled',
      };

  factory LaundryOrder.fromMap(Map<String, dynamic> map) => LaundryOrder(
        id: map['id'] ?? '',
        customerId: map['customer_id'] ?? '',
        storeName: map['store_name'] ?? 'Laundry Service',
        storeImageUrl: map['store_image_url'] ?? '',
        service: map['service'] ?? '',
        address: map['address'] ?? '',
        phone: map['phone'] ?? '',
        pickupTime: map['pickup_time'] ?? '',
        deliveryDate: map['delivery_date'] ?? '',
        status: map['status'],
        createdAt: map['created_at'],
      );
}
