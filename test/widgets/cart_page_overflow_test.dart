import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_01/features/delivery/domain/entities/address.dart';
import 'package:project_01/features/delivery/presentation/providers/address_provider.dart';
import 'package:project_01/features/delivery/presentation/providers/delivery_provider.dart';
import 'package:project_01/models/product.dart';
import 'package:project_01/pages/cart_provider.dart';
import 'package:project_01/pages/orders_provider.dart';
import 'package:project_01/widgets/cartpage.dart';
import 'package:provider/provider.dart';

Widget _buildCartTestWidget({
  required CartProvider cart,
  required DeliveryProvider delivery,
  required AddressProvider address,
  required OrdersProvider orders,
  double textScale = 1.0,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<CartProvider>.value(value: cart),
      ChangeNotifierProvider<DeliveryProvider>.value(value: delivery),
      ChangeNotifierProvider<AddressProvider>.value(value: address),
      ChangeNotifierProvider<OrdersProvider>.value(value: orders),
    ],
    child: MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: const CartPage(),
      ),
    ),
  );
}

void main() {
  testWidgets('CartPage renders empty state without overflow at 320x568', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final cart = CartProvider();
    final delivery = DeliveryProvider();
    final address = AddressProvider();
    final orders = OrdersProvider();

    await tester.pumpWidget(
      _buildCartTestWidget(
        cart: cart,
        delivery: delivery,
        address: address,
        orders: orders,
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text("Your cart is empty"), findsOneWidget);
  });

  testWidgets('CartPage in delivery mode renders without overflow at 360x640', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final cart = CartProvider();
    cart.addProduct(
      ProductModel(
        name: 'Milk',
        price: 2.5,
        image: 'assets/images/milk.png',
        weight: '1L',
        unit: 'L',
        category: 'Dairy',
        boxColor: Colors.white,
      ),
      2,
    );

    final delivery = DeliveryProvider();
    delivery.setType('delivery');
    delivery.selectAddress(const Address(
      id: 'addr1',
      label: 'Home',
      line1: '123 Market St',
      city: 'Jaipur',
      lat: 26.9124,
      lng: 75.7873,
    ));

    final address = AddressProvider();
    final orders = OrdersProvider();

    await tester.pumpWidget(
      _buildCartTestWidget(
        cart: cart,
        delivery: delivery,
        address: address,
        orders: orders,
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('CartPage in delivery mode renders without overflow at 320x568 with textScale 2.0',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final cart = CartProvider();
    cart.addProduct(
      ProductModel(
        name: 'Milk',
        price: 2.5,
        image: 'assets/images/milk.png',
        weight: '1L',
        unit: 'L',
        category: 'Dairy',
        boxColor: Colors.white,
      ),
      1,
    );

    final delivery = DeliveryProvider();
    delivery.setType('delivery');

    final address = AddressProvider();
    final orders = OrdersProvider();

    await tester.pumpWidget(
      _buildCartTestWidget(
        cart: cart,
        delivery: delivery,
        address: address,
        orders: orders,
        textScale: 2.0,
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
