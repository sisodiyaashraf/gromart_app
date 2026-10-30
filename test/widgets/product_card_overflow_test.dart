import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_01/core/theme/app_theme.dart';
import 'package:project_01/models/product.dart';
import 'package:project_01/pages/product_list_screen.dart';
import 'package:project_01/widgets/productcart.dart';

void main() {
  final sampleProduct = ProductModel(
    name: "Fresh Organic Broccoli Florets Extra Large Pack",
    image: "assets/images/broccali.png",
    weight: "500g",
    price: 4.50,
    unit: "kg",
    boxColor: const Color(0xFFE8F5E9),
    category: "Vegetables",
  );

  Widget createTestWidget({
    required double textScale,
    required double width,
    required double height,
  }) {
    return MediaQuery(
      data: MediaQueryData(
        size: Size(width, height),
        textScaler: TextScaler.linear(textScale),
      ),
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProductList(products: [sampleProduct, sampleProduct]),
          ),
        ),
      ),
    );
  }

  testWidgets('ProductCard renders without overflow at width 320 with textScaler 1.0',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestWidget(textScale: 1.0, width: 320, height: 568),
    );
    await tester.pump();

    expect(find.byType(ProductCard), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('ProductCard renders without overflow at width 320 with textScaler 1.3',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestWidget(textScale: 1.3, width: 320, height: 568),
    );
    await tester.pump();

    expect(find.byType(ProductCard), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('ProductCard renders without overflow at width 320 with textScaler 2.0',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      createTestWidget(textScale: 2.0, width: 320, height: 568),
    );
    await tester.pump();

    expect(find.byType(ProductCard), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
