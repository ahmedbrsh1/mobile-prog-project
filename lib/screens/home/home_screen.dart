import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // import مهم
import '../../services/api_service.dart';
import '../../models/product_model.dart';
import '../../services/wishlist_service.dart'; // استدعاء السيرفيس الجديد
import '../cart/cart_screen.dart';
import '../profile/wishlist_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/account_info_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});
  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreenContent(),
    const WishlistScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF9775FA),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: "Wallet"),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    bool isDarkMode = false;
    void navigateTo(Widget page) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    }

    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 50),
          InkWell(
            onTap: () => navigateTo(const AccountInfoScreen()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                children: [
                  const CircleAvatar(radius: 25, backgroundImage: NetworkImage("https://i.pravatar.cc/300")),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Mrh Raju", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(children: [const Text("Verified Profile", style: TextStyle(color: Colors.grey, fontSize: 12)), const SizedBox(width: 5), Icon(Icons.verified, size: 14, color: Colors.green[400])]),
                    ],
                  ),
                  const Spacer(),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(5)), child: const Text("3 Orders", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Row(children: [Icon(Icons.wb_sunny_outlined, size: 22), SizedBox(width: 15), Text("Dark Mode", style: TextStyle(fontSize: 15))]), Switch(value: isDarkMode, activeColor: const Color(0xFF9775FA), onChanged: (val) {})]),
          ),
          const SizedBox(height: 10),
          _drawerItem(Icons.info_outline, "Account Information", onTap: () => navigateTo(const AccountInfoScreen())),
          _drawerItem(Icons.lock_outline, "Password"),
          _drawerItem(Icons.shopping_bag_outlined, "Order", onTap: () => navigateTo(const CartScreen())),
          _drawerItem(Icons.credit_card, "My Cards", onTap: () => navigateTo(const ProfileScreen())),
          _drawerItem(Icons.favorite_border, "Wishlist", onTap: () => navigateTo(const WishlistScreen())),
          _drawerItem(Icons.settings_outlined, "Settings"),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () async { await FirebaseAuth.instance.signOut(); if (!context.mounted) return; Navigator.pushReplacementNamed(context, '/login'); },
              child: const Row(children: [Icon(Icons.logout, color: Colors.red), SizedBox(width: 10), Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))]),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(leading: Icon(icon, color: Colors.black87), title: Text(title, style: const TextStyle(fontSize: 15)), onTap: onTap ?? () {});
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});
  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  late Future<List<Product>> futureProducts;
  String selectedBrand = "All";
  String searchQuery = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> brands = [
    {"name": "Adidas", "logo": "https://upload.wikimedia.org/wikipedia/commons/2/20/Adidas_Logo.svg"},
    {"name": "Nike", "logo": "https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg"},
    {"name": "Fila", "logo": "https://upload.wikimedia.org/wikipedia/commons/f/fd/Fila_logo.svg"},
    {"name": "Puma", "logo": "https://upload.wikimedia.org/wikipedia/commons/8/88/Puma_Logo.png"},
  ];

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: Padding(padding: const EdgeInsets.only(left: 15.0), child: CircleAvatar(backgroundColor: Colors.grey[100], child: IconButton(icon: const Icon(Icons.menu_open_rounded, color: Colors.black), onPressed: () => Scaffold.of(context).openDrawer()))),
        actions: [Padding(padding: const EdgeInsets.only(right: 15.0), child: CircleAvatar(backgroundColor: Colors.grey[100], child: IconButton(icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black), onPressed: () => Navigator.pushNamed(context, '/cart'))))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("Welcome to Laza.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container(height: 50, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)), child: TextField(onChanged: (value) => setState(() => searchQuery = value), decoration: const InputDecoration(border: InputBorder.none, prefixIcon: Icon(Icons.search, color: Colors.grey), hintText: "Search...", hintStyle: TextStyle(color: Colors.grey), contentPadding: EdgeInsets.symmetric(vertical: 15))))),
                const SizedBox(width: 10),
                Container(height: 50, width: 50, decoration: BoxDecoration(color: const Color(0xFF9775FA), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.mic, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Choose Brand", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)), GestureDetector(onTap: () => setState(() => selectedBrand = "All"), child: const Text("View All", style: TextStyle(color: Colors.grey)))]),
            const SizedBox(height: 15),
            SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: brands.map((brand) => GestureDetector(onTap: () => setState(() => selectedBrand = brand["name"]!), child: Container(margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: selectedBrand == brand["name"] ? const Color(0xFF9775FA) : Colors.grey[100], borderRadius: BorderRadius.circular(10)), child: Row(children: [Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.branding_watermark, size: 20, color: Colors.black)), const SizedBox(width: 10), Text(brand["name"]!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: selectedBrand == brand["name"] ? Colors.white : Colors.black))])) )).toList())),
            const SizedBox(height: 20),
            const Text("New Arrival", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 10),
            
            // --- هنا الشغل كله: بحث + مفضلة فايربيز ---
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  
                  var displayList = snapshot.data!;
                  if (selectedBrand != "All") displayList = displayList.where((p) => p.title.toLowerCase().contains(selectedBrand.toLowerCase())).toList();
                  if (searchQuery.isNotEmpty) displayList = displayList.where((p) => p.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
                  if (displayList.isEmpty) return const Center(child: Text("No items found"));

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 15, mainAxisSpacing: 15),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final product = displayList[index];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/details', arguments: product),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: NetworkImage(product.images.isNotEmpty ? product.images[0] : ''), fit: BoxFit.cover)),
                                // --- أيقونة القلب متصلة بالفايربيز ---
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: WishlistService().isFavoriteStream(product.id),
                                      builder: (context, snapshot) {
                                        bool isFav = snapshot.hasData && snapshot.data!.docs.isNotEmpty;
                                        return InkWell(
                                          onTap: () => WishlistService().toggleWishlist(product),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white.withOpacity(0.8),
                                            radius: 16,
                                            child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey, size: 20),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("\$${product.price}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}