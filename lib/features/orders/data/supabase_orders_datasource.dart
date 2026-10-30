import 'package:flutter/foundation.dart';
import 'package:project_01/models/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseOrdersDatasource {
  final SupabaseClient? _customClient;

  SupabaseOrdersDatasource({SupabaseClient? client}) : _customClient = client;

  SupabaseClient get _client => _customClient ?? Supabase.instance.client;

  Future<OrderModel> insertOrder(OrderModel order, String userId) async {
    try {
      final response = await _client
          .from('orders')
          .insert(order.toJson(userId))
          .select()
          .single();
      return OrderModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException inserting order: ${e.message} (${e.code})');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error inserting order: $e');
      rethrow;
    }
  }

  Future<List<OrderModel>> fetchOrders(String userId) async {
    try {
      final data = await _client
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (data as List)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException fetching orders: ${e.message} (${e.code})');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error fetching orders: $e');
      rethrow;
    }
  }
}
