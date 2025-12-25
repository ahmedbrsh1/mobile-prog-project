import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // لو مفعلة عندك

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String uId = FirebaseAuth.instance.currentUser!.uid; // هات الـ ID

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders"), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: uId) // الفلتر الذهبي
            .orderBy('orderDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text("No orders yet!", style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            );
          }

          var orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var data = orders[index].data() as Map<String, dynamic>;
              var items = data['items'] as List<dynamic>;
              
              // (باقي الكود زي ما هو بالظبط للعرض)
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF9775FA).withOpacity(0.1),
                    child: const Icon(Icons.shopping_bag, color: Color(0xFF9775FA)),
                  ),
                  title: Text("Order: ${data['totalAmount'].toStringAsFixed(2)}\$", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(data['status'] ?? "Pending", style: const TextStyle(color: Colors.orange)),
                  children: items.map((item) {
                    return ListTile(
                      leading: Image.network(item['image'], width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(item['title']),
                      trailing: Text("\$${item['totalPrice']}"),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}