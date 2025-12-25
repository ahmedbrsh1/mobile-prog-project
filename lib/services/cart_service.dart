import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // عشان نجيب الـ ID
import '../models/product_model.dart';

class CartService {
  final CollectionReference cartRef = FirebaseFirestore.instance.collection('carts');
  final FirebaseAuth auth = FirebaseAuth.instance;

  // جلب User ID الحالي
  String get uId => auth.currentUser!.uid;

  Future<void> addToCart(Product product, String size) async {
    // بنشوف هل المنتج ده موجود لنفس اليوزر ولا لأ
    QuerySnapshot query = await cartRef
        .where('userId', isEqualTo: uId) // فلتر باليوزر
        .where('id', isEqualTo: product.id)
        .where('size', isEqualTo: size)
        .get();

    if (query.docs.isNotEmpty) {
      var doc = query.docs.first;
      int currentQty = doc['quantity'];
      await doc.reference.update({
        'quantity': currentQty + 1,
        'totalPrice': (currentQty + 1) * product.price,
      });
    } else {
      await cartRef.add({
        'userId': uId, // أهم سطر: ربط المنتج باليوزر
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.images[0],
        'quantity': 1,
        'size': size,
        'totalPrice': product.price,
      });
    }
  }

  Future<void> removeFromCart(String docId) async {
    await cartRef.doc(docId).delete();
  }

  Future<void> updateQuantity(String docId, int currentQty, double price, int change) async {
    int newQty = currentQty + change;
    if (newQty > 0) {
      await cartRef.doc(docId).update({
        'quantity': newQty,
        'totalPrice': newQty * price,
      });
    }
  }

  // الستريم بيجيب بس منتجات اليوزر الحالي
  Stream<QuerySnapshot> getCartStream() {
    return cartRef.where('userId', isEqualTo: uId).snapshots();
  }
}