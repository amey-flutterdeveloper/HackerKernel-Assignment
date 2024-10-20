import 'dart:convert';

class Product {
  final String name;
  final double price;
  final String? imagePath; 

  Product({
    required this.name,
    required this.price,
    this.imagePath, 
  });

  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imagePath': imagePath, 
    };
  }

  
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      price: map['price'].toDouble(), 
      imagePath: map['imagePath'], 
    );
  }

  
  static String encode(List<Product> products) {
    return json.encode(
      products.map<Map<String, dynamic>>((product) => product.toMap()).toList(),
    );
  }

  
  static List<Product> decode(String products) {
    return (json.decode(products) as List<dynamic>)
        .map<Product>((item) => Product.fromMap(item))
        .toList();
  }
}
