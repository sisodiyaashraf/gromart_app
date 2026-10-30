import '../entities/address.dart';

/// Contract for address operations.
abstract class AddressRepository {
  Future<List<Address>> getAddresses(String userId);
  Future<Address> addAddress(Address address, String userId, {required bool isDefault});
  Future<Address> updateAddress(Address address, String userId);
  Future<void> deleteAddress(String addressId, String userId);
  Future<void> setDefaultAddress(String addressId, String userId);
}
