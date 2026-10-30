import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_01/models/order.dart';
import 'package:project_01/features/orders/domain/orders_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  final OrdersRepository _repository = SupabaseOrdersRepository();
  late final StreamSubscription<AuthState> _authSub;

  OrdersProvider() {
    // Subscribe to auth state changes
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((AuthState state) async {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        await _loadOrders(session.user.id);
      } else {
        _orders.clear();
        notifyListeners();
      }
    });
    // Load orders immediately if already signed in
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      _loadOrders(userId);
    }
  }

  List<OrderModel> get orders => List.unmodifiable(_orders);



  Future<void> _loadOrders(String userId) async {
    try {
      final fetched = await _repository.getOrders(userId);
      _orders
        ..clear()
        ..addAll(fetched);
      notifyListeners();
    } catch (e) {
      // In a real app you might surface this error to UI
      debugPrint('Failed to load orders: $e');
    }
  }

  Future<void> addOrder(OrderModel order) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      // Not signed in – you could throw or simply ignore
      debugPrint('Attempted to add order without a signed‑in user');
      return;
    }
    try {
      await _repository.addOrder(order, userId);
      // Optimistically insert at the top of the list
      _orders.insert(0, order);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to add order: $e');
    }
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
