import 'package:project_01/models/order.dart';
import 'supabase_orders_datasource.dart';

abstract class OrdersRepository {
  Future<void> addOrder(OrderModel order, String userId);
  Future<List<OrderModel>> getOrders(String userId);
}

class SupabaseOrdersRepository implements OrdersRepository {
  final SupabaseOrdersDatasource _datasource = SupabaseOrdersDatasource();

  @override
  Future<void> addOrder(OrderModel order, String userId) async {
    await _datasource.insertOrder(order, userId);
  }

  @override
  Future<List<OrderModel>> getOrders(String userId) async {
    return await _datasource.fetchOrders(userId);
  }
}
