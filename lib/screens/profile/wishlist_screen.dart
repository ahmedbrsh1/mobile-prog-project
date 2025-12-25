import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/product_model.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      // الاستماع للتغيرات في القائمة
      body: ValueListenableBuilder<List<Product>>(
        valueListenable: AppData.wishlistNotifier,
        builder: (context, wishlist, child) {
          if (wishlist.isEmpty) return const Center(child: Text("No favorites yet", style: TextStyle(color: Colors.grey)));
          
          return GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 15, mainAxisSpacing: 15),
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              final product = wishlist[index];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/details', arguments: product),
                child: Column(
                  children: [
                    Expanded(child: Container(decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15), image: DecorationImage(image: NetworkImage(product.images[0]), fit: BoxFit.cover)),
                      // زر الحذف من المفضلة
                      child: Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => AppData.toggleWishlist(product))),
                    )),
                    const SizedBox(height: 5),
                    Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text("\$${product.price}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}