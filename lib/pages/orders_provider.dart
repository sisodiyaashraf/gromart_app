import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:project_01/features/orders/domain/orders_repository.dart';
import 'package:project_01/models/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersProvider extends ChangeNotifier {
  final OrdersRepository _repository;
  final List<OrderModel> _orders = [];
  StreamSubscription<AuthState>? _authSub;

  bool _isLoading = false;
  String? _error;
  bool _loginPaused = false;
  String? _userId;
  String? _userPhone;
  String? _userName;

  OrdersProvider({OrdersRepository? repository})
      : _repository = repository ?? SupabaseOrdersRepository() {
    _initAuth();
  }

  List<OrderModel> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _userId;
  String? get userPhone => _userPhone;
  String? get userName => _userName;

  void _initAuth() {
    try {
      final client = Supabase.instance.client;
      final currentSession = client.auth.currentSession;
      if (currentSession != null) {
        _syncUserData(currentSession.user);
        _loadOrders(currentSession.user.id);
      }

      _authSub = client.auth.onAuthStateChange.listen((data) {
        if (_loginPaused) return;
        final session = data.session;
        if (data.event == AuthChangeEvent.initialSession ||
            data.event == AuthChangeEvent.signedIn) {
          if (session != null) {
            _syncUserData(session.user);
            _loadOrders(session.user.id);
          }
        } else if (data.event == AuthChangeEvent.signedOut) {
          _userId = null;
          _userPhone = null;
          _userName = null;
          _orders.clear();
          _error = null;
          notifyListeners();
        }
      });
    } catch (_) {
      // Allows testing in environments where Supabase is not initialized
    }
  }

  void _syncUserData(User user) {
    _userId = user.id;
    _userPhone = user.phone;
    _userName = user.userMetadata?['name'];
  }

  Future<void> _loadOrders(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final fetched = await _repository.getOrders(userId);
      _orders
        ..clear()
        ..addAll(fetched);
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to load orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderModel> placeOrder(OrderModel order) async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) {
      const err = 'User not logged in';
      _error = err;
      notifyListeners();
      throw Exception(err);
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final savedOrder = await _repository.addOrder(order, uid);
      _orders.insert(0, savedOrder);
      return savedOrder;
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to place order: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrder(OrderModel order) async {
    await placeOrder(order);
  }

  Future<void> debugAdvanceStatus(String orderId) async {
    if (!kDebugMode) return;
    try {
      await Supabase.instance.client.rpc(
        'dev_advance_order_status',
        params: {'p_order_id': orderId},
      );
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid != null) {
        await _loadOrders(uid);
      }
    } catch (e) {
      debugPrint('Error advancing order status: $e');
    }
  }

  void pauseLogin() => _loginPaused = true;
  void resumeLogin() => _loginPaused = false;

  Future<void> updateUserProfile({String? name, String? phone}) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (data.isEmpty) return;
    try {
      await Supabase.instance.client.auth.updateUser(UserAttributes(data: data));
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
    _authSub?.cancel();
    super.dispose();
  }
}
