import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class WishlistService {
  final CollectionReference wishlistRef = FirebaseFirestore.instance.collection('wishlist');
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get uId => auth.currentUser!.uid;

  Future<void> toggleWishlist(Product product) async {
    // بحث عن المنتج لليوزر الحالي فقط
    final query = await wishlistRef
        .where('userId', isEqualTo: uId) // فلتر باليوزر
        .where('id', isEqualTo: product.id)
        .get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.delete();
    } else {
      await wishlistRef.add({
        'userId': uId, // ربط باليوزر
        "id": product.id,
        "title": product.title,
        "price": product.price,
        "image": product.images[0],
        "description": product.description,
        "category": product.category,
      });
    }
  }

  Stream<QuerySnapshot> isFavoriteStream(int productId) {
    return wishlistRef
        .where('userId', isEqualTo: uId) // فلتر باليوزر
        .where('id', isEqualTo: productId)
        .snapshots();
  }

  Stream<QuerySnapshot> getWishlistStream() {
    return wishlistRef.where('userId', isEqualTo: uId).snapshots(); // فلتر باليوزر
  }
}