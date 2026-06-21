class LaundryStore {
  final String id;
  final String name;
  final String imageUrl;

  const LaundryStore({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

final List<LaundryStore> dummyLaundryStores = [
  LaundryStore(
    id: 'al-nada',
    name: 'Al Nada Laundry',
    imageUrl: 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=400&q=80',
  ),
  LaundryStore(
    id: 'aman-clean',
    name: 'Aman Clean',
    imageUrl: 'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?w=400&q=80',
  ),
  LaundryStore(
    id: 'royal-press',
    name: 'Royal Press',
    imageUrl: 'https://images.unsplash.com/photo-1604335399105-a0c585fd81a1?w=400&q=80',
  ),
  LaundryStore(
    id: 'petra-wash',
    name: 'Petra Wash',
    imageUrl: 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?q=80&w=1171',
  ),
];
