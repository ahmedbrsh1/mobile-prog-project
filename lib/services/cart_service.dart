import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class CartService {
  final CollectionReference cartRef = FirebaseFirestore.instance.collection('carts');

  // 1. دالة إضافة منتج للكارت
  Future<void> addToCart(Product product, String size) async {
    // التصحيح: شلنا return عشان الدالة نوعها void
    await cartRef.add({
      "id": product.id,
      "title": product.title,
      "price": product.price,
      "image": product.images[0], 
      "quantity": 1,
      "size": size,
      "totalPrice": product.price,
    });
  }

  // 2. دالة جلب البيانات
  Stream<QuerySnapshot> getCartStream() {
    return cartRef.snapshots();
  }

  // 3. دالة تحديث الكمية
  Future<void> updateQuantity(String docId, int currentQty, double price, int change) async {
    int newQty = currentQty + change;
    if (newQty < 1) return; 

    // التصحيح: استخدمنا await بدل return
    await cartRef.doc(docId).update({
      "quantity": newQty,
      "totalPrice": newQty * price, 
    });
  }

  // 4. دالة الحذف
  Future<void> removeFromCart(String docId) async {
    await cartRef.doc(docId).delete();
  }
}