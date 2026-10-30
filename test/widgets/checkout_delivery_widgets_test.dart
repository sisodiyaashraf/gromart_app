import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_01/features/delivery/domain/entities/address.dart';
import 'package:project_01/features/delivery/presentation/providers/address_provider.dart';
import 'package:project_01/features/delivery/presentation/providers/delivery_provider.dart';
import 'package:project_01/features/delivery/presentation/widgets/address_tile.dart';
import 'package:project_01/features/delivery/presentation/widgets/checkout_delivery_widget.dart';
import 'package:project_01/features/delivery/presentation/widgets/delivery_toggle.dart';
import 'package:project_01/features/delivery/presentation/widgets/fee_summary.dart';
import 'package:project_01/features/delivery/presentation/widgets/instructions_field.dart';
import 'package:project_01/features/delivery/presentation/widgets/slot_picker.dart';
import 'package:provider/provider.dart';

Widget _wrapWidget({
  required Widget child,
  required DeliveryProvider deliveryProvider,
  required AddressProvider addressProvider,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<DeliveryProvider>.value(value: deliveryProvider),
      ChangeNotifierProvider<AddressProvider>.value(value: addressProvider),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          ),
        ),
      ),
    ),
  );
}

void main() {
  late DeliveryProvider deliveryProvider;
  late AddressProvider addressProvider;

  setUp(() {
    deliveryProvider = DeliveryProvider();
    addressProvider = AddressProvider();
  });

  testWidgets('DeliveryToggle renders at width 320 with textScale 2.0 without exception',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: _wrapWidget(
          child: const DeliveryToggle(),
          deliveryProvider: deliveryProvider,
          addressProvider: addressProvider,
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(DeliveryToggle), findsOneWidget);
  });

  testWidgets('AddressTile renders pickup and delivery at width 320 with textScale 2.0 without exception',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Pickup
    deliveryProvider.setType('pickup');
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: _wrapWidget(
          child: const AddressTile(),
          deliveryProvider: deliveryProvider,
          addressProvider: addressProvider,
        ),
      ),
    );
    expect(tester.takeException(), isNull);

    // Delivery with selected address
    deliveryProvider.setType('delivery');
    deliveryProvider.selectAddress(const Address(
      id: '1',
      label: 'Home',
      line1: '123 Test St',
      city: 'Jaipur',
      lat: 26.9124,
      lng: 75.7873,
    ));

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: _wrapWidget(
          child: const AddressTile(),
          deliveryProvider: deliveryProvider,
          addressProvider: addressProvider,
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('FeeSummary renders at width 320 with textScale 2.0 without exception',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    deliveryProvider.setType('delivery');
    deliveryProvider.setAddressDetails(
      text: 'Sample',
      lat: 26.9200,
      lng: 75.7900,
    );

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: _wrapWidget(
          child: const FeeSummary(),
          deliveryProvider: deliveryProvider,
          addressProvider: addressProvider,
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('SlotPicker renders at width 320 with textScale 2.0 without exception',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    deliveryProvider.setType('delivery');

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: _wrapWidget(
          child: const SlotPicker(),
          deliveryProvider: deliveryProvider,
          addressProvider: addressProvider,
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('InstructionsField renders at width 320 with textScale 2.0 without exception',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    deliveryProvider.setType('delivery');

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: _wrapWidget(
          child: const InstructionsField(),
          deliveryProvider: deliveryProvider,
          addressProvider: addressProvider,
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('CheckoutDeliveryWidget composer renders at width 320 with textScale 2.0 without exception',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    deliveryProvider.setType('delivery');
    deliveryProvider.selectAddress(const Address(
      id: '1',
      label: 'Home',
      line1: '123 Market St',
      city: 'Jaipur',
      lat: 26.9124,
      lng: 75.7873,
    ));

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: _wrapWidget(
          child: const CheckoutDeliveryWidget(),
          deliveryProvider: deliveryProvider,
          addressProvider: addressProvider,
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
