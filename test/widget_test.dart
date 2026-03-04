import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shopping_cart_mvvm/main.dart' as app;

void main() {
  testWidgets('App should render initial products screen',
      (WidgetTester tester) async {
    app.main();

    await tester.pumpAndSettle();

    expect(find.text('Produtos'), findsOneWidget);
  });
}
