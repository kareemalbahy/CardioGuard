import 'package:flutter_test/flutter_test.dart';
import 'package:cardiogaurd/app/app.dart';
import 'package:cardiogaurd/app/di/injection_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App loads', (WidgetTester tester) async {
    await sl.reset();
    await configureDependencies();
    await tester.pumpWidget(const CardioGuardApp());
    await tester.pump();
    expect(find.byType(CardioGuardApp), findsOneWidget);
  });
}
