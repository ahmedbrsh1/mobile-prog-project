import 'package:flutter/material.dart';
import '../../data/app_data.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  // فتح صفحة تعديل العنوان (Full Screen Style)
  void _openAddressPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddressEditScreen()));
  }

  // فتح صفحة تعديل البطاقة
  void _openPaymentPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PaymentEditScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart"), centerTitle: true),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: AppData.cartNotifier,
        builder: (context, cartItems, child) {
          if (cartItems.isEmpty) return const Center(child: Text("Cart is Empty!", style: TextStyle(fontSize: 18, color: Colors.grey)));
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...cartItems.map((item) => Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(width: 90, height: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage(item.product.images[0]), fit: BoxFit.cover))),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(item.product.title, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text("\$${item.product.price}", style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 10),
                              Row(children: [
                                  InkWell(onTap: () => AppData.updateQuantity(item.product, -1), child: const CircleAvatar(radius: 14, backgroundColor: Colors.grey, child: Icon(Icons.remove, size: 16, color: Colors.white))),
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold))),
                                  InkWell(onTap: () => AppData.updateQuantity(item.product, 1), child: const CircleAvatar(radius: 14, backgroundColor: Color(0xFF9775FA), child: Icon(Icons.add, size: 16, color: Colors.white))),
                                  const Spacer(),
                                  IconButton(icon: const Icon(Icons.delete_outline, color: Colors.grey), onPressed: () => AppData.removeFromCart(item.product))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),

                const SizedBox(height: 20),
                // Address Section
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Delivery Address", style: TextStyle(fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 15), onPressed: _openAddressPage)]),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.map_outlined, color: Colors.orange)),
                    const SizedBox(width: 15),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AppData.deliveryAddress, style: const TextStyle(fontWeight: FontWeight.bold)), const Text("Sylhet", style: TextStyle(color: Colors.grey, fontSize: 12))])),
                    const Icon(Icons.check_circle, color: Colors.green)
                  ]),
                ),

                const SizedBox(height: 15),
                // Payment Section
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 15), onPressed: _openPaymentPage)]),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.credit_card, color: Colors.blue)),
                    const SizedBox(width: 15),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AppData.paymentMethod, style: const TextStyle(fontWeight: FontWeight.bold)), const Text("**** 7690", style: TextStyle(color: Colors.grey, fontSize: 12))])),
                    const Icon(Icons.check_circle, color: Colors.green)
                  ]),
                ),

                const SizedBox(height: 30),
                const Text("Order Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Subtotal", style: TextStyle(color: Colors.grey)), Text("\$${AppData.subtotal.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold))]),
                const SizedBox(height: 5),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Shipping cost", style: TextStyle(color: Colors.grey)), Text("\$${AppData.shipping}", style: const TextStyle(fontWeight: FontWeight.bold))]),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text("\$${AppData.total.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9775FA), fontSize: 18))]),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9775FA), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          onPressed: () => Navigator.pushNamed(context, '/success'),
          child: const Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// --- صفحة تعديل العنوان (كما في الصورة) ---
class AddressEditScreen extends StatelessWidget {
  const AddressEditScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Address"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInput("Name", "Mrh Raju"),
            const SizedBox(height: 15),
            Row(children: [Expanded(child: _buildInput("Country", "Bangladesh")), const SizedBox(width: 15), Expanded(child: _buildInput("City", "Sylhet"))]),
            const SizedBox(height: 15),
            _buildInput("Phone Number", "+880 1453-987533"),
            const SizedBox(height: 15),
            _buildInput("Address", "Chhatak, Sunamgonj 12/8AB"),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Save as primary address"), Switch(value: true, activeColor: const Color(0xFF9775FA), onChanged: (v){})]),
            const Spacer(),
            SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9775FA), padding: const EdgeInsets.all(18)), onPressed: (){ AppData.deliveryAddress = "Chhatak, Sunamgonj 12/8AB"; Navigator.pop(context); }, child: const Text("Save Address", style: TextStyle(color: Colors.white, fontSize: 17))))
          ],
        ),
      ),
    );
  }
  Widget _buildInput(String label, String initVal) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 5), TextFormField(initialValue: initVal, decoration: InputDecoration(filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)))]);
  }
}

// --- صفحة تعديل البطاقة (Wallet / Payment) ---
class PaymentEditScreen extends StatelessWidget {
  const PaymentEditScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // صورة الكارت
            Container(width: double.infinity, height: 200, decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFF9775FA), Colors.purpleAccent])), child: const Center(child: Text("VISA", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)))),
            const SizedBox(height: 20),
            Container(width: double.infinity, height: 50, decoration: BoxDecoration(color: Colors.purple[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF9775FA))), child: const Center(child: Text("+ Add new card", style: TextStyle(color: Color(0xFF9775FA), fontWeight: FontWeight.bold)))),
            const SizedBox(height: 20),
             _buildInput("Card Owner", "Mrh Raju"),
             const SizedBox(height: 15),
             _buildInput("Card Number", "5254 7634 8734 7690"),
             const SizedBox(height: 15),
             Row(children: [Expanded(child: _buildInput("EXP", "24/24")), const SizedBox(width: 15), Expanded(child: _buildInput("CVV", "7763"))]),
             const Spacer(),
             SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9775FA), padding: const EdgeInsets.all(18)), onPressed: (){ AppData.paymentMethod = "Visa Classic"; Navigator.pop(context); }, child: const Text("Save Card", style: TextStyle(color: Colors.white, fontSize: 17))))
          ],
        ),
      ),
    );
  }
  Widget _buildInput(String label, String initVal) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 5), TextFormField(initialValue: initVal, decoration: InputDecoration(filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)))]);
  }
}