import 'package:flutter/material.dart';
import '../models/product_model.dart';

// كلاس يمثل العنصر داخل السلة (المنتج + العدد)
class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class AppData {
  // استخدام ValueNotifier لتحديث الشاشات تلقائياً عند تغير البيانات
  static ValueNotifier<List<CartItem>> cartNotifier = ValueNotifier([]);
  static ValueNotifier<List<Product>> wishlistNotifier = ValueNotifier([]);
  
  // بيانات العنوان والدفع الافتراضية
  static String deliveryAddress = "Chhatak, Sunamgonj 12/8AB";
  static String paymentMethod = "Visa Classic **** 7690";

  // --- دوال السلة (Cart Logic) ---

  static void addToCart(Product product) {
    // نأخذ نسخة من القائمة الحالية لتعديلها
    List<CartItem> currentCart = List.from(cartNotifier.value);
    
    // نبحث هل المنتج موجود مسبقاً؟
    final index = currentCart.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      currentCart[index].quantity++; // لو موجود زود العدد
    } else {
      currentCart.add(CartItem(product: product)); // لو جديد ضيفه
    }
    
    // تحديث القيمة سيجبر الشاشات على إعادة الرسم
    cartNotifier.value = currentCart;
  }

  static void removeFromCart(Product product) {
    List<CartItem> currentCart = List.from(cartNotifier.value);
    currentCart.removeWhere((item) => item.product.id == product.id);
    cartNotifier.value = currentCart;
  }

  static void updateQuantity(Product product, int change) {
    List<CartItem> currentCart = List.from(cartNotifier.value);
    final index = currentCart.indexWhere((item) => item.product.id == product.id);
    
    if (index != -1) {
      currentCart[index].quantity += change;
      // إذا أصبحت الكمية صفر، نحذف المنتج
      if (currentCart[index].quantity <= 0) {
        currentCart.removeAt(index);
      }
      cartNotifier.value = currentCart;
    }
  }

  // --- دوال المفضلة (Wishlist Logic) ---

  static bool isInWishlist(Product product) {
    return wishlistNotifier.value.any((p) => p.id == product.id);
  }

  static void toggleWishlist(Product product) {
    List<Product> currentWishlist = List.from(wishlistNotifier.value);
    
    if (currentWishlist.any((p) => p.id == product.id)) {
      currentWishlist.removeWhere((p) => p.id == product.id);
    } else {
      currentWishlist.add(product);
    }
    
    wishlistNotifier.value = currentWishlist;
  }

  // --- حسابات الأسعار ---
  static double get subtotal => cartNotifier.value.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  static double get shipping => cartNotifier.value.isEmpty ? 0 : 10.0;
  static double get total => subtotal + shipping;
}