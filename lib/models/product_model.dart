class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      // معالجة روابط الصور وتنظيفها
      images: (json['images'] as List)
          .map((item) => item.toString().replaceAll('["', '').replaceAll('"]', ''))
          .toList(),
      category: json['category']['name'],
    );
  }
}