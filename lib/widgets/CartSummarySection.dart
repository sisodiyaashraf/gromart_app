import 'package:flutter/material.dart';
import 'package:project_01/models/order.dart';
import 'package:project_01/models/product.dart';
import 'package:project_01/pages/cart_provider.dart';
import 'package:project_01/pages/orders_provider.dart';
import 'package:project_01/widgets/order.dart';
import 'package:provider/provider.dart';

/// ✅ Simple Promo Result model
class PromoResult {
  final bool valid;
  final String code;
  final double discount;
  final String message;

  PromoResult({
    required this.valid,
    required this.code,
    required this.discount,
    required this.message,
  });
}

/// ✅ PromoService inline helper
class PromoService {
  static PromoResult applyPromo(
      String code, double subtotal, double deliveryFee) {
    if (code.toUpperCase() == "SAVE10") {
      final discount = subtotal * 0.1;
      return PromoResult(
        valid: true,
        code: "SAVE10",
        discount: discount,
        message: "10% off applied! 🎉",
      );
    } else if (code.toUpperCase() == "FREESHIP" && deliveryFee > 0) {
      return PromoResult(
        valid: true,
        code: "FREESHIP",
        discount: deliveryFee,
        message: "Free delivery unlocked 🚚",
      );
    }
    return PromoResult(
      valid: false,
      code: code,
      discount: 0,
      message: "Invalid promo code ❌",
    );
  }

  static Future<void> savePromo(String code) async {
    // Simulate saving promo code
  }

  static Future<String?> loadPromo() async {
    // Simulate loading promo code
    return null;
  }

  static Future<void> clearPromo() async {
    // Simulate clearing promo code
  }
}

class CartSummarySection extends StatefulWidget {
  final CartProvider cart;
  const CartSummarySection({super.key, required this.cart});

  @override
  State<CartSummarySection> createState() => _CartSummarySectionState();
}

class _CartSummarySectionState extends State<CartSummarySection>
    with SingleTickerProviderStateMixin {
  final TextEditingController _promoController = TextEditingController();

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  bool _showBottom = false;
  double _discount = 0;
  bool _invalidPromo = false;
  bool _validPromo = false;
  String _appliedCode = "";

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 12)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _showBottom = true);
    });

    _loadSavedPromo();
  }

  Future<void> _loadSavedPromo() async {
    final savedCode = await PromoService.loadPromo();
    if (savedCode != null && mounted) {
      final cart = widget.cart;
      final deliveryFee = cart.totalPrice > 50 ? 0.0 : 4.99;
      _applyPromo(savedCode, cart.totalPrice, deliveryFee, silent: true);
      _promoController.text = savedCode;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _applyPromo(String code, double subtotal, double deliveryFee,
      {bool silent = false}) async {
    final result = PromoService.applyPromo(code, subtotal, deliveryFee);

    setState(() {
      _discount = result.discount;
      _invalidPromo = !result.valid;
      _validPromo = result.valid;
      _appliedCode = result.valid ? result.code : "";
    });

    if (result.valid) {
      await PromoService.savePromo(result.code);
    } else {
      if (_shakeController.isAnimating) _shakeController.reset();
      _shakeController.forward();
    }

    if (!silent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }

  void _removePromo() async {
    await PromoService.clearPromo();
    setState(() {
      _validPromo = false;
      _invalidPromo = false;
      _discount = 0;
      _promoController.clear();
      _appliedCode = "";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Promo removed ❌")),
    );
  }

  /// ✅ Now properly defined
  void _showOffersBottomSheet(
      BuildContext context, double subtotal, double deliveryFee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final offers = ["SAVE10", "FREESHIP"];

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.45,
          maxChildSize: 0.85,
          minChildSize: 0.3,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Available Offers 🎉",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: offers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final code = offers[index];
                        final result = PromoService.applyPromo(
                            code, subtotal, deliveryFee);

                        return Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Icon(
                              code == "SAVE10"
                                  ? Icons.percent
                                  : Icons.local_shipping,
                              color: Colors.green,
                            ),
                            title: Text(code,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(result.message),
                            trailing: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _promoController.text = code;
                                _applyPromo(code, subtotal, deliveryFee);
                              },
                              child: const Text("Apply"),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPriceRow(String label, String value,
      {bool bold = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 18 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
              color: highlight ? Colors.green : Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 18 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: highlight ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);

    double deliveryFee = cart.totalPrice > 50 ? 0.0 : 4.99;
    double finalTotal = cart.totalPrice + deliveryFee - _discount;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 500),
      offset: _showBottom ? Offset.zero : const Offset(0, 1),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: _showBottom ? 1 : 0,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🎁 Promo Chip
              if (_validPromo)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      avatar: const Icon(Icons.local_offer,
                          color: Colors.white, size: 18),
                      label: Text(
                        PromoService.applyPromo(
                                _appliedCode, cart.totalPrice, deliveryFee)
                            .message,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                      deleteIcon: const Icon(Icons.close, color: Colors.white),
                      onDeleted: _removePromo,
                    ),
                  ),
                ),

              // Promo Input
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _invalidPromo
                              ? Colors.red
                              : _validPromo
                                  ? Colors.green
                                  : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          if (_validPromo)
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                          else
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child:
                                Icon(Icons.card_giftcard, color: Colors.green),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              decoration: const InputDecoration(
                                hintText: "Enter promo code",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _applyPromo(
                              _promoController.text,
                              cart.totalPrice,
                              deliveryFee,
                            ),
                            child: const Text("Apply",
                                style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _showOffersBottomSheet(
                          context,
                          cart.totalPrice,
                          deliveryFee,
                        ),
                        icon:
                            const Icon(Icons.local_offer, color: Colors.green),
                        label: const Text("See Offers",
                            style: TextStyle(color: Colors.green)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Price Details
              _buildPriceRow(
                  "Subtotal", "\$${cart.totalPrice.toStringAsFixed(2)}"),
              _buildPriceRow(
                "Delivery Fee",
                deliveryFee == 0.0
                    ? "Free"
                    : "\$${deliveryFee.toStringAsFixed(2)}",
                highlight: deliveryFee == 0.0,
              ),
              if (_discount > 0)
                _buildPriceRow(
                  "Discount",
                  "-\$${_discount.toStringAsFixed(2)}",
                  highlight: true,
                ),
              const Divider(height: 30, thickness: 1),
              _buildPriceRow("Total", "\$${finalTotal.toStringAsFixed(2)}",
                  bold: true, highlight: true),
              const SizedBox(height: 16),

              // Checkout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                    shadowColor: Colors.green.withOpacity(0.3),
                  ),
                  onPressed: () async {
                    if (cart.cartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Your cart is empty!")),
                      );
                      return;
                    }

                    final newOrder = OrderModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      date: DateTime.now(),
                      items: cart.cartItems
                          .map((e) => e['product'] as ProductModel)
                          .toList(),
                      total: finalTotal,
                      status: "Pending",
                    );

                    ordersProvider.addOrder(newOrder);
                    cart.clearCart();
                    await PromoService.clearPromo();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Order placed successfully!")),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const OrdersPage()),
                    );
                  },
                  child: const Text(
                    "Proceed to Checkout",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
