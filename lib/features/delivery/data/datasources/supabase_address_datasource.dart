import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/address_model.dart';

/// Datasource for interacting with the Supabase `addresses` table.
class SupabaseAddressDatasource {
  final SupabaseClient? _customClient;

  SupabaseAddressDatasource({SupabaseClient? client}) : _customClient = client;

  SupabaseClient get _client => _customClient ?? Supabase.instance.client;

  Future<List<AddressModel>> fetchAddresses(String userId) async {
    try {
      final response = await _client
          .from('addresses')
          .select()
          .eq('user_id', userId);
      return (response as List)
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException fetching addresses: ${e.message} (${e.code})');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error fetching addresses: $e');
      rethrow;
    }
  }

  Future<AddressModel> insertAddress(AddressModel address, String userId) async {
    try {
      final response = await _client
          .from('addresses')
          .insert(address.toInsertJson(userId))
          .select()
          .single();
      return AddressModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException inserting address: ${e.message} (${e.code})');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error inserting address: $e');
      rethrow;
    }
  }

  Future<AddressModel> updateAddress(AddressModel address, String userId) async {
    try {
      final response = await _client
          .from('addresses')
          .update(address.toUpdateJson())
          .eq('id', address.id)
          .eq('user_id', userId)
          .select()
          .single();
      return AddressModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException updating address: ${e.message} (${e.code})');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error updating address: $e');
      rethrow;
    }
  }

  Future<void> deleteAddress(String addressId, String userId) async {
    try {
      await _client
          .from('addresses')
          .delete()
          .eq('id', addressId)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException deleting address: ${e.message} (${e.code})');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error deleting address: $e');
      rethrow;
    }
  }

  Future<void> clearDefaultAddress(String userId) async {
    try {
      await _client
          .from('addresses')
          .update({'is_default': false})
          .eq('user_id', userId)
          .eq('is_default', true);
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException clearing default address: ${e.message} (${e.code})');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error clearing default address: $e');
      rethrow;
    }
  }

  Future<void> setDefaultAddress(String addressId, String userId) async {
    try {
      // Clear old default first to satisfy unique partial index
      await clearDefaultAddress(userId);
      await _client
          .from('addresses')
          .update({'is_default': true})
          .eq('id', addressId)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException setting default address: ${e.message} (${e.code})');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error setting default address: $e');
      rethrow;
    }
  }
}
