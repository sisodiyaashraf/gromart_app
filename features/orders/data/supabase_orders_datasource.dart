import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_01/models/order.dart';

class SupabaseOrdersDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  Future<OrderModel> insertOrder(OrderModel order, String userId) async {
    final response = await _client
        .from('orders')
        .insert(order.toJson(userId))
        .select()
        .single();
    return OrderModel.fromJson(response);
  }

  Future<List<OrderModel>> fetchOrders(String userId) async {
    final response = await _client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .execute();
    if (response.error != null) {
      throw response.error!;
    }
    final List data = response.data as List;
    return data.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
