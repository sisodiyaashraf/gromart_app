import 'package:flutter_test/flutter_test.dart';
import 'package:project_01/config/store_config.dart';
import 'package:project_01/features/delivery/data/models/address_model.dart';
import 'package:project_01/features/delivery/presentation/providers/delivery_provider.dart';
import 'package:project_01/features/delivery/utils/distance_calculator.dart';

void main() {
  group('DistanceCalculator Tests', () {
    test('same point returns distance of 0 km', () {
      final distance = DistanceCalculator.calculateDistanceKm(
        lat1: StoreConfig.storeLat,
        lng1: StoreConfig.storeLng,
        lat2: StoreConfig.storeLat,
        lng2: StoreConfig.storeLng,
      );
      expect(distance, closeTo(0.0, 0.0001));
    });

    test('1 degree of latitude difference is approximately 111.2 km', () {
      final distance = DistanceCalculator.calculateDistanceKm(
        lat1: 26.0,
        lng1: 75.0,
        lat2: 27.0,
        lng2: 75.0,
      );
      expect(distance, closeTo(111.19, 0.5));
    });
  });

  group('AddressModel Serialization Tests', () {
    test('toInsertJson keys exactly match required columns', () {
      const address = AddressModel(
        id: 'some-uuid',
        userId: 'user-123',
        label: 'Home',
        line1: '123 Market St',
        line2: 'Suite 4',
        city: 'Jaipur',
        state: 'Rajasthan',
        zip: '302001',
        lat: 26.9124,
        lng: 75.7873,
        isDefault: true,
      );

      final insertJson = address.toInsertJson('user-123');

      final expectedKeys = {
        'user_id',
        'label',
        'line1',
        'line2',
        'city',
        'state',
        'zip',
        'lat',
        'lng',
        'is_default',
      };

      expect(insertJson.keys.toSet(), equals(expectedKeys));
      expect(insertJson.containsKey('id'), isFalse);
      expect(insertJson.containsKey('created_at'), isFalse);
      expect(insertJson.containsKey('updated_at'), isFalse);
      expect(insertJson['user_id'], 'user-123');
      expect(insertJson['is_default'], true);
    });

    test('toUpdateJson contains updated_at and excludes id, user_id, created_at', () {
      const address = AddressModel(
        id: 'some-uuid',
        label: 'Office',
        line1: '456 Business Blvd',
        city: 'Jaipur',
        lat: 26.9000,
        lng: 75.8000,
      );

      final updateJson = address.toUpdateJson();

      expect(updateJson.containsKey('updated_at'), isTrue);
      expect(updateJson.containsKey('id'), isFalse);
      expect(updateJson.containsKey('user_id'), isFalse);
      expect(updateJson.containsKey('created_at'), isFalse);
    });
  });

  group('DeliveryProvider Tests', () {
    late DeliveryProvider provider;

    setUp(() {
      provider = DeliveryProvider();
    });

    test('pickup mode has fee = 0', () {
      provider.setType('pickup');
      expect(provider.fee, 0.0);
      expect(provider.isPickup, isTrue);
    });

    test('delivery fee = baseFee + km * perKmRate and rounds to 2 decimals', () {
      provider.setType('delivery');

      // Coordinate approx 2 km away from store
      // lat: 26.9124, lng: 75.7873
      const nearLat = 26.9304;
      const nearLng = 75.7873;

      final km = DistanceCalculator.calculateDistanceKm(
        lat1: StoreConfig.storeLat,
        lng1: StoreConfig.storeLng,
        lat2: nearLat,
        lng2: nearLng,
      );

      final expectedFee = double.parse(
        (StoreConfig.baseFee + (km * StoreConfig.perKmRate)).toStringAsFixed(2),
      );

      provider.setAddressDetails(
        text: 'Nearby Destination',
        lat: nearLat,
        lng: nearLng,
      );

      expect(provider.fee, equals(expectedFee));
      expect(provider.isValidDelivery, isTrue);
    });

    test('address with null coordinates has fee 0 and isValidDelivery = false', () {
      provider.setType('delivery');
      provider.setAddressDetails(
        text: 'No GPS Address',
        lat: null,
        lng: null,
      );

      expect(provider.fee, 0.0);
      expect(provider.isValidDelivery, isFalse);
      expect(provider.needsMapLocation, isTrue);
    });

    test('beyond maxDeliveryKm is invalid', () {
      provider.setType('delivery');

      // Coordinates 50km away
      provider.setAddressDetails(
        text: 'Faraway Place',
        lat: 27.5000,
        lng: 75.7873,
      );

      expect(provider.distanceKm! > StoreConfig.maxDeliveryKm, isTrue);
      expect(provider.isValidDelivery, isFalse);
    });

    test('rejects slots in the past', () {
      final pastDate = DateTime.now().subtract(const Duration(hours: 2));
      final accepted = provider.setSlot(pastDate);

      expect(accepted, isFalse);
      expect(provider.slot, isNull);

      final futureDate = DateTime.now().add(const Duration(hours: 2));
      final futureAccepted = provider.setSlot(futureDate);

      expect(futureAccepted, isTrue);
      expect(provider.slot, equals(futureDate));
    });

    test('reset() clears all delivery state', () {
      provider.setType('delivery');
      provider.setAddressDetails(
        text: '123 Main St',
        lat: 26.9200,
        lng: 75.7900,
      );
      provider.setInstructions('Leave at door');
      provider.setSlot(DateTime.now().add(const Duration(days: 1)));

      provider.reset();

      expect(provider.type, 'pickup');
      expect(provider.selectedAddressText, isNull);
      expect(provider.selectedLat, isNull);
      expect(provider.selectedLng, isNull);
      expect(provider.fee, 0.0);
      expect(provider.slot, isNull);
      expect(provider.instructions, isEmpty);
    });
  });
}
