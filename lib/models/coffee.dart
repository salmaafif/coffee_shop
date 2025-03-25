class Coffee {
  final String image;
  final String name;
  final String type;
  final int review;
  final String desc;
  final double price;

  Coffee({
    required this.image,
    required this.name,
    required this.type,
    required this.review,
    required this.desc,
    required this.price,
  });
}

final coffeeList = [
  Coffee(
    image: 'assets/kopisusuaren.webp',
    name: 'Kopi Susu Aren',
    type: 'Coffee',
    review: 95,
    desc: 'Kombinasi dari kopi, gula aren asli, dan susu yang creamy',
    price: 22000,
  ),
  Coffee(
    image: 'assets/kopisusuaren.webp',
    name: 'Kopi Susu Aren',
    type: 'Coffee',
    review: 95,
    desc: 'Kombinasi dari kopi, gula aren asli, dan susu yang creamy',
    price: 22000,
  ),
];
