import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/supabase_address_datasource.dart';
import '../models/address_model.dart';

/// Supabase implementation of AddressRepository.
class SupabaseAddressRepository implements AddressRepository {
  final SupabaseAddressDatasource _datasource;

  SupabaseAddressRepository({SupabaseAddressDatasource? datasource})
      : _datasource = datasource ?? SupabaseAddressDatasource();

  @override
  Future<List<Address>> getAddresses(String userId) async {
    return await _datasource.fetchAddresses(userId);
  }

  @override
  Future<Address> addAddress(
    Address address,
    String userId, {
    required bool isDefault,
  }) async {
    if (isDefault) {
      await _datasource.clearDefaultAddress(userId);
    }
    final model = AddressModel(
      id: address.id,
      userId: userId,
      label: address.label,
      line1: address.line1,
      line2: address.line2,
      city: address.city,
      state: address.state,
      zip: address.zip,
      lat: address.lat,
      lng: address.lng,
      isDefault: isDefault,
    );
    return await _datasource.insertAddress(model, userId);
  }

  @override
  Future<Address> updateAddress(Address address, String userId) async {
    final model = AddressModel.fromEntity(address);
    return await _datasource.updateAddress(model, userId);
  }

  @override
  Future<void> deleteAddress(String addressId, String userId) async {
    await _datasource.deleteAddress(addressId, userId);
  }

  @override
  Future<void> setDefaultAddress(String addressId, String userId) async {
    await _datasource.setDefaultAddress(addressId, userId);
  }
}
