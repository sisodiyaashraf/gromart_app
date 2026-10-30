import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_01/models/order.dart';
import 'package:project_01/features/orders/domain/orders_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  final OrdersRepository _repository = SupabaseOrdersRepository();
  late final StreamSubscription<AuthState> _authSub;
  bool _loginPaused = false; // flag to pause login handling
  String? _userId;
  String? _userPhone;
  String? _userName;

  String? get userId => _userId;
  String? get userPhone => _userPhone;
  String? get userName => _userName;

  OrdersProvider() {
    // Subscribe to auth state changes
    _authSub = Supabase.instance.client.auth.onAuthStateChange
        .listen((AuthState state) async {
      if (_loginPaused) return;
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        _userId = session.user.id;
        _userPhone = session.user.phone;
        _userName = session.user.userMetadata?['name'];
        await _loadOrders(session.user.id);
      } else {
        _userId = null;
        _userPhone = null;
        _userName = null;
        _orders.clear();
        notifyListeners();
      }
    });
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      _userId = user.id;
      _userPhone = user.phone;
      _userName = user.userMetadata?['name'];
      _loadOrders(user.id);
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

  /// Pause handling of auth state changes (e.g., mobile number login).
  void pauseLogin() {
    _loginPaused = true;
    debugPrint('Login handling paused');
  }

  /// Resume handling of auth state changes.
  void resumeLogin() {
    _loginPaused = false;
    debugPrint('Login handling resumed');
  }

  /// Update user profile (name and/or phone).
  Future<void> updateUserProfile({String? name, String? phone}) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (data.isEmpty) return;
    try {
      await Supabase.instance.client.auth
          .updateUser(UserAttributes(data: data));
      // Refresh cached values
      final user = Supabase.instance.client.auth.currentUser;
      _userName = user?.userMetadata?['name'];
      _userPhone = user?.phone;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to update user profile: $e');
    }
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
