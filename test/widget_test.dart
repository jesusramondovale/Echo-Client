import 'package:echo/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EchoApp builds', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EchoApp()));
    expect(find.byType(EchoApp), findsOneWidget);
  });
}
