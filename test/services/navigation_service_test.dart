// // test/services/navigation_service_test.dart
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:fcmchatapp/services/navigation_service.dart';
// import '../mocks.mocks.dart';

// void main() {
//   late NavigationService navigationService;
//   late MockNavigatorState mockNavigatorState;

//   setUp(() {
//     navigationService = NavigationService();
//     mockNavigatorState = MockNavigatorState();
//     navigationService.navigatorKey.currentState = mockNavigatorState;
//   });

//   test('navigatorKey should be initialized', () {
//     expect(navigationService.navigatorKey, isNotNull);
//   });

//   test('navigateTo should push named route', () {
//     navigationService.navigateTo('/test');
//     verify(mockNavigatorState.pushNamed('/test')).called(1);
//   });

//   test('replaceWith should replace route', () {
//     navigationService.replaceWith('/home');
//     verify(mockNavigatorState.pushReplacementNamed('/home')).called(1);
//   });
// }