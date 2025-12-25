import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class WishlistService {
  final CollectionReference wishlistRef = FirebaseFirestore.instance.collection('wishlist');

  // دالة إضافة أو حذف المنتج (Toggle)
  Future<void> toggleWishlist(Product product) async {
    // بنبحث هل المنتج ده موجود أصلاً في الفايربيز ولا لأ
    final query = await wishlistRef.where('id', isEqualTo: product.id).get();

    if (query.docs.isNotEmpty) {
      // لو موجود -> امسحه (Unlike)
      await query.docs.first.reference.delete();
    } else {
      // لو مش موجود -> ضيفه (Like)
      await wishlistRef.add({
        "id": product.id,
        "title": product.title,
        "price": product.price,
        "image": product.images[0], // بناخد أول صورة
        "description": product.description,
        "category": product.category, // بنحفظ الاسم بس
      });
    }
  }

  // دالة عشان نعرف المنتج ده Fav ولا لأ (عشان لون القلب)
  Stream<QuerySnapshot> isFavoriteStream(int productId) {
    return wishlistRef.where('id', isEqualTo: productId).snapshots();
  }

  // دالة جلب كل المفضلات لصفحة الـ Wishlist
  Stream<QuerySnapshot> getWishlistStream() {
    return wishlistRef.snapshots();
  }
}