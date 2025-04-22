// // test/routes/route_generator_test.dart
// import 'package:fcmchatapp/utils/route_generator.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
// import 'package:fcmchatapp/views/pages/login_page.dart';

// void main() {
//   test('generateRoute returns LoginPage for /login', () {
//     final route = RouteGenerator.generateRoute(
//       const RouteSettings(name: '/login'),
//     );
//     expect(route, isA<MaterialPageRoute>());
//     expect((route as MaterialPageRoute).builder(null), isA<LoginPage>());
//   });

//   test('generateRoute returns ErrorRoute for unknown route', () {
//     final route = RouteGenerator.generateRoute(
//       const RouteSettings(name: '/unknown'),
//     );
//     expect(route, isA<MaterialPageRoute>());
//     expect(find.text('No route defined for /unknown'), findsOneWidget);
//   });
// }