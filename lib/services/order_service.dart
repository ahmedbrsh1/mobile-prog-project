import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // دالة إتمام الطلب
  Future<void> placeOrder({
    required double totalAmount,
    required String address,
    required String paymentMethod,
  }) async {
    WriteBatch batch = _firestore.batch();
    
    // 1. نجيب كل المنتجات اللي في الكارت
    QuerySnapshot cartSnapshot = await _firestore.collection('carts').get();
    List<Map<String, dynamic>> items = [];

    if (cartSnapshot.docs.isEmpty) {
      return; // لو الكارت فاضي منعملش حاجة
    }

    // نجهز قائمة المنتجات عشان نحطها في الطلب
    for (var doc in cartSnapshot.docs) {
      items.add(doc.data() as Map<String, dynamic>);
      
      // 2. نضيف أمر مسح المنتج من الكارت (تفريغ الكارت)
      batch.delete(doc.reference);
    }

    // 3. نجهز بيانات الطلب الجديد
    DocumentReference orderRef = _firestore.collection('orders').doc(); // بنعمل ID جديد للطلب
    batch.set(orderRef, {
      "orderId": orderRef.id,
      "items": items, // قائمة المنتجات
      "totalAmount": totalAmount,
      "address": address,
      "paymentMethod": paymentMethod,
      "status": "Pending", // حالة الطلب (قيد الانتظار)
      "orderDate": FieldValue.serverTimestamp(), // وقت الطلب
    });

    // 4. تنفيذ كل العمليات (إنشاء الطلب + مسح الكارت) مرة واحدة
    await batch.commit();
  }
}