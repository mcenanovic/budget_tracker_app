enum Category {
  clothing,
  electronics,
  transport,
}

class Item {
  String id;
  final String name;
  final Category category;
  final double price;
  final DateTime dateTime;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.dateTime,
  });

  factory Item.fromRTDB(Map<String, dynamic> data) {
    return Item(
        id: data['id'],
        name: data['name'],
        category: data['category'],
        price: data['price'],
        dateTime: data['dateTime']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category.index,
        'price': price,
        'dateTime': dateTime.toIso8601String()
      };
}
