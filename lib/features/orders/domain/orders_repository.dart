import 'package:project_01/models/order.dart';
import '../data/supabase_orders_datasource.dart';

abstract class OrdersRepository {
  Future<OrderModel> addOrder(OrderModel order, String userId);
  Future<List<OrderModel>> getOrders(String userId);
}

class SupabaseOrdersRepository implements OrdersRepository {
  final SupabaseOrdersDatasource _datasource;

  SupabaseOrdersRepository({SupabaseOrdersDatasource? datasource})
      : _datasource = datasource ?? SupabaseOrdersDatasource();

  @override
  Future<OrderModel> addOrder(OrderModel order, String userId) async {
    return await _datasource.insertOrder(order, userId);
  }

  @override
  Future<List<OrderModel>> getOrders(String userId) async {
    return await _datasource.fetchOrders(userId);
  }
}
