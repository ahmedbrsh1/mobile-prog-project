import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../data/app_data.dart';
import '../../services/cart_service.dart'; // استدعاء السيرفيس

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String selectedSize = "M";

  // دالة إضافة مراجعة (Dialog) - زي ما هي
  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Write a Review"),
        content: const TextField(decoration: InputDecoration(hintText: "Describe your experience...", border: OutlineInputBorder()), maxLines: 3),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9775FA)),
            onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Review Submitted!"))); }, 
            child: const Text("Submit", style: TextStyle(color: Colors.white))
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: Padding(padding: const EdgeInsets.all(8.0), child: CircleAvatar(backgroundColor: Colors.white, child: const BackButton(color: Colors.black))),
        actions: [
          Padding(padding: const EdgeInsets.all(8.0), child: CircleAvatar(backgroundColor: Colors.white, child: ValueListenableBuilder<List<Product>>(
            valueListenable: AppData.wishlistNotifier,
            builder: (context, wishlist, child) {
              bool isFav = AppData.isInWishlist(product);
              return IconButton(icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.black), onPressed: () => AppData.toggleWishlist(product));
            },
          )))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 350, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], image: DecorationImage(image: NetworkImage(product.images[0]), fit: BoxFit.cover))),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(product.category, style: const TextStyle(color: Colors.grey)), const Text("Price", style: TextStyle(color: Colors.grey))]),
                  const SizedBox(height: 5),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))), Text("\$${product.price}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))]),
                  const SizedBox(height: 15),
                  // Images Row
                  Row(children: product.images.take(4).map((img) => Container(margin: const EdgeInsets.only(right: 10), width: 70, height: 70, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover)))).toList()),
                  const SizedBox(height: 20),
                  const Text("Size", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(children: ["S", "M", "L", "XL", "2XL"].map((size) => GestureDetector(onTap: () => setState(() => selectedSize = size), child: Container(margin: const EdgeInsets.only(right: 10), width: 50, height: 50, alignment: Alignment.center, decoration: BoxDecoration(color: selectedSize == size ? const Color(0xFF9775FA) : Colors.grey[100], borderRadius: BorderRadius.circular(10)), child: Text(size, style: TextStyle(color: selectedSize == size ? Colors.white : Colors.black, fontWeight: FontWeight.bold))))).toList()),
                  const SizedBox(height: 20),
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(product.description, style: const TextStyle(color: Colors.grey, height: 1.5)),
                  const SizedBox(height: 20),
                  
                  // --- قسم المراجعات ---
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton(onPressed: _showAddReviewDialog, child: const Text("Add Review", style: TextStyle(color: Color(0xFF9775FA))))
                  ]),
                  
                  _buildReviewItem("Ronald Richards", "13 Sep, 2020", 4.8, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet..."),
                  _buildReviewItem("Jenny Wilson", "12 Sep, 2020", 4.5, "Great product! highly recommended."),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9775FA), padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          // --- هنا التعديل: استدعاء السيرفيس ---
          onPressed: () {
            CartService().addToCart(product, selectedSize).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Added to Cart Successfully! 🛒"),
                backgroundColor: Colors.green,
              ));
            }).catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
            });
          },
          child: const Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildReviewItem(String name, String date, double rating, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundImage: NetworkImage("https://i.pravatar.cc/150")), // صورة وهمية
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold)), Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12))]),
              const Spacer(),
              Column(children: [Text("$rating rating", style: const TextStyle(fontWeight: FontWeight.bold)), Row(children: const [Icon(Icons.star, color: Colors.orange, size: 12), Icon(Icons.star, color: Colors.orange, size: 12), Icon(Icons.star, color: Colors.orange, size: 12), Icon(Icons.star, color: Colors.orange, size: 12), Icon(Icons.star, color: Colors.orange, size: 12)])])
            ],
          ),
          const SizedBox(height: 10),
          Text(text, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}