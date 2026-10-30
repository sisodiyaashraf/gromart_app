import 'package:flutter/material.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/utils/currency_formatter.dart';
import 'package:project_01/features/delivery/presentation/providers/delivery_provider.dart';
import 'package:project_01/features/delivery/presentation/widgets/checkout_delivery_widget.dart';
import 'package:project_01/models/order.dart';
import 'package:project_01/models/product.dart';
import 'package:project_01/pages/cart_provider.dart';
import 'package:project_01/pages/orders_provider.dart';
import 'package:project_01/widgets/order.dart';
import 'package:provider/provider.dart';

/// Simple Promo Result model
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

/// PromoService inline helper
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
  bool _isPlacingOrder = false;

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
      final deliveryProvider = context.read<DeliveryProvider>();
      _applyPromo(savedCode, cart.totalPrice, deliveryProvider.fee, silent: true);
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Promo removed ❌")),
      );
    }
  }

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
                              color: AppColors.primary,
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
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: bold ? 18 : 16,
                fontWeight: bold ? FontWeight.bold : FontWeight.w400,
                color: highlight ? AppColors.primary : Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 18 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: highlight ? AppColors.primary : Colors.black,
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
    final deliveryProvider = context.watch<DeliveryProvider>();

    final double deliveryFee = deliveryProvider.fee;
    final double finalTotal =
        (cart.totalPrice + deliveryFee - _discount).clamp(0.0, double.infinity);

    final bool isDeliveryInvalid =
        deliveryProvider.isDelivery && !deliveryProvider.isValidDelivery;
    final bool canPlaceOrder =
        !_isPlacingOrder && !isDeliveryInvalid && cart.cartItems.isNotEmpty;

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
            color: Colors.white.withAlpha(0xE6),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(0x14),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🚚 Delivery / Pickup Configuration
              const CheckoutDeliveryWidget(),
              const SizedBox(height: 16),

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
                      backgroundColor: AppColors.primary,
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
                                  ? AppColors.primary
                                  : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          if (_validPromo)
                            BoxShadow(
                              color: AppColors.primary.withAlpha(0x4D),
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                          else
                            BoxShadow(
                              color: Colors.black.withAlpha(0x0D),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child:
                                Icon(Icons.card_giftcard, color: AppColors.primary),
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
                            child: Text("Apply",
                                style: TextStyle(color: AppColors.primary)),
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
                        icon: Icon(Icons.local_offer, color: AppColors.primary),
                        label: Text("See Offers",
                            style: TextStyle(color: AppColors.primary)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Price Details
              _buildPriceRow(
                  "Subtotal", CurrencyFormatter.format(cart.totalPrice)),
              _buildPriceRow(
                "Delivery Fee",
                deliveryFee == 0.0
                    ? "Free"
                    : CurrencyFormatter.format(deliveryFee),
                highlight: deliveryFee == 0.0,
              ),
              if (_discount > 0)
                _buildPriceRow(
                  "Discount",
                  "-${CurrencyFormatter.format(_discount)}",
                  highlight: true,
                ),
              const Divider(height: 30, thickness: 1),
              _buildPriceRow("Total", CurrencyFormatter.format(finalTotal),
                  bold: true, highlight: true),
              const SizedBox(height: 16),

              // Checkout Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: canPlaceOrder ? 4 : 0,
                  ),
                  onPressed: canPlaceOrder
                      ? () async {
                          if (cart.cartItems.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Your cart is empty!"),
                              ),
                            );
                            return;
                          }

                          setState(() => _isPlacingOrder = true);

                          try {
                            final snapshotItems = cart.cartItems.map((e) {
                              final p = e['product'] as ProductModel;
                              final q = (e['quantity'] as num?)?.toInt() ?? 1;
                              return OrderItem(
                                productId: p.name,
                                name: p.name,
                                price: p.price,
                                quantity: q,
                                image: p.image,
                                weight: p.weight,
                              );
                            }).toList();

                            final newOrder = OrderModel(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              date: DateTime.now(),
                              items: snapshotItems,
                              total: finalTotal,
                              status: "pending",
                              deliveryType: deliveryProvider.type,
                              deliveryAddressText:
                                  deliveryProvider.selectedAddressText,
                              deliveryLat: deliveryProvider.selectedLat,
                              deliveryLng: deliveryProvider.selectedLng,
                              deliveryFee: deliveryProvider.fee,
                              deliverySlot: deliveryProvider.slot,
                              deliveryInstructions: deliveryProvider
                                      .instructions.trim().isNotEmpty
                                  ? deliveryProvider.instructions.trim()
                                  : null,
                            );

                            await ordersProvider.placeOrder(newOrder);

                            cart.clearCart();
                            await PromoService.clearPromo();
                            deliveryProvider.reset();

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Order placed successfully!"),
                              ),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OrdersPage(),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to place order: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _isPlacingOrder = false);
                            }
                          }
                        }
                      : null,
                  child: _isPlacingOrder
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isDeliveryInvalid
                              ? "Select Valid Delivery Address"
                              : "Proceed to Checkout",
                          style: const TextStyle(
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
