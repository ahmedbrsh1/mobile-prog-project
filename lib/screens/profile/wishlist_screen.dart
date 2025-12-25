import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/wishlist_service.dart';
import '../../models/product_model.dart'; // import عشان الـ Product model

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist"), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: WishlistService().getWishlistStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.favorite_border, size: 80, color: Colors.grey), SizedBox(height: 20), Text("No favorites yet!", style: TextStyle(color: Colors.grey, fontSize: 18))]));
          }

          var docs = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 15, mainAxisSpacing: 15),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              
              // بنجهز الموديل عشان لما ندوس يروح للتفاصيل
              Product product = Product(id: data['id'], title: data['title'], price: data['price'], description: data['description'], images: [data['image']], category: data['category']);

              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/details', arguments: product),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 5)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), image: DecorationImage(image: NetworkImage(data['image']), fit: BoxFit.cover))),
                            Positioned(
                              top: 8, right: 8,
                              child: CircleAvatar(
                                backgroundColor: Colors.white, radius: 16,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () => WishlistService().toggleWishlist(product), // حذف
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data['title'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)), Text("\$${data['price']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9775FA)))]),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}