✅ Moving to Step 4: Unit Testing Dio API Service
This is one of the most important skills for professional Flutter apps.

We will learn:

✔ How to test API calls
✔ How to mock Dio (fake response)
✔ How to test success / failure
✔ How to test model parsing with the API
✔ No real network requests (pure unit test)

We will use:
http_mock_adapter — best package for mocking Dio.


✅ Step 4 — Setup Mock Dio
🔹 Step 4.1 — Add dependency

In pubspec.yaml:

dev_dependencies:
  http_mock_adapter: ^0.6.0
  dio: ^5.7.0
  flutter_test:


Run:

flutter pub get

✅ Step 4.2 — Create Example API Service
File: lib/services/user_service.dart
import 'package:dio/dio.dart';
import '../models/user_model.dart';

class UserService {
  final Dio dio;

  UserService(this.dio);

  Future<UserModel> fetchUser() async {
    final response = await dio.get('/user');

    return UserModel.fromJson(response.data);
  }
}


✔ This service calls /user
✔ Response JSON → parsed into UserModel

✅ Step 4.3 — Create test using MockAdapter
File: test/services/user_service_test.dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:your_app_name/services/user_service.dart';
import 'package:your_app_name/models/user_model.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late UserService service;

  setUp(() {
    dio = Dio(BaseOptions());
    dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;
    service = UserService(dio);
  });

  test('fetchUser returns UserModel on success', () async {
    final mockJson = {
      "id": 1,
      "name": "tarik",
      "email": "e@e.com",
      "balance": 100.0
    };

    dioAdapter.onGet(
      '/user',
      (server) => server.reply(200, mockJson),
    );

    final user = await service.fetchUser();

    expect(user, isA<UserModel>());
    expect(user.id, 1);
    expect(user.name, "tarik");
  });

  test('fetchUser throws DioException on 404 error', () async {
    dioAdapter.onGet(
      '/user',
      (server) => server.reply(404, {"message": "Not found"}),
    );

    expect(
      () => service.fetchUser(),
      throwsA(isA<DioException>()),
    );
  });
}

🔍 Explanation (Bangla + English)
✔ DioAdapter

Mock server for Dio. No real HTTP call.

✔ onGet('/user', ...)

We tell the mock server:

If any code calls GET /user, return this fake response.

✔ Success response test

Mock gives JSON

Service parses it

We test model data

✔ Error response test

Mock returns 404

We test exception is thrown

🧠 Bangla Summary

👉 Real API ke hit kora hoy na
👉 Mock server e bola hoy “tumi jodi /user call pao, ei data return diba”
👉 Success & Failure duita test kora hoy
👉 Eita pro-level backend mocking

🚀 What You Learned in Step 4

✔ Mocking Dio without internet
✔ Testing API service functions
✔ Testing success response
✔ Testing error response
✔ Model + API combined testing
✔ No UI needed — pure fast unit tests

🔜 Step 5 Preview — Riverpod + Dio API Integration Test

Next step we will test:

Riverpod StateNotifier calling API service

How to mock service inside Riverpod test

Updating state based on API result

Testing loading → success → error

This is crucial for real apps.