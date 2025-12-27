import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> placeOrder({
    required double totalAmount,
    required String address,
    required String paymentMethod,
  }) async {
    String uId = auth.currentUser!.uid;
    WriteBatch batch = _firestore.batch();
    
    QuerySnapshot cartSnapshot = await _firestore
        .collection('carts')
        .where('userId', isEqualTo: uId) // مهم جداً
        .get();

    List<Map<String, dynamic>> items = [];

    if (cartSnapshot.docs.isEmpty) return;

    for (var doc in cartSnapshot.docs) {
      items.add(doc.data() as Map<String, dynamic>);
      batch.delete(doc.reference); // مسح من السلة
    }

    DocumentReference orderRef = _firestore.collection('orders').doc();
    batch.set(orderRef, {
      "orderId": orderRef.id,
      "userId": uId, // تسجيل صاحب الطلب
      "items": items,
      "totalAmount": totalAmount,
      "address": address,
      "paymentMethod": paymentMethod,
      "status": "Pending",
      "orderDate": FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
}