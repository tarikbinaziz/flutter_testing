import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_all/models/user_model.dart';
import 'package:flutter_testing_all/unit_test/dio_api_service/services/user_service.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

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

  // ================================
  // GET TEST
  // ================================
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

  // ================================
  // POST TEST
  // ================================
  test('createUser returns UserModel on success', () async {
    final mockBody = {"name": "tarik", "email": "e@e.com"};
    final mockResponse = {
      "id": 1,
      "name": "tarik",
      "email": "e@e.com",
      "balance": 0.0
    };

    dioAdapter.onPost(
      '/user',
      data: mockBody,
      (server) => server.reply(201, mockResponse),
    );

    final user = await service.createUser(mockBody);

    expect(user, isA<UserModel>());
    expect(user.id, 1);
    expect(user.email, "e@e.com");
  });

  test('createUser throws DioException on error', () async {
    final mockBody = {"name": "tarik"};

    dioAdapter.onPost(
      '/user',
      data: mockBody,
      (server) => server.reply(400, {"message": "Bad Request"}),
    );

    expect(
      () => service.createUser(mockBody),
      throwsA(isA<DioException>()),
    );
  });

  // ================================
  // PUT TEST
  // ================================
  test('updateUser returns updated UserModel on success', () async {
    final updatedBody = {"name": "Updated"};
    final mockResponse = {
      "id": 1,
      "name": "Updated",
      "email": "e@e.com",
      "balance": 100.0
    };

    dioAdapter.onPut(
      '/user/1',
      data: updatedBody,
      (server) => server.reply(200, mockResponse),
    );

    final user = await service.updateUser(1, updatedBody);

    expect(user.name, "Updated");
  });

  test('updateUser throws DioException on error', () async {
    final updatedBody = {"name": "Updated"};

    dioAdapter.onPut(
      '/user/1',
      data: updatedBody,
      (server) => server.reply(500, {"message": "Server error"}),
    );

    expect(
      () => service.updateUser(1, updatedBody),
      throwsA(isA<DioException>()),
    );
  });

  // ================================
  // DELETE TEST
  // ================================
  test('deleteUser returns true on success', () async {
    dioAdapter.onDelete(
      '/user/1',
      (server) => server.reply(200, {"success": true}),
    );

    final result = await service.deleteUser(1);

    expect(result, true);
  });

  test('deleteUser throws DioException on error', () async {
    dioAdapter.onDelete(
      '/user/1',
      (server) => server.reply(404, {"message": "Not found"}),
    );

    expect(
      () => service.deleteUser(1),
      throwsA(isA<DioException>()),
    );
  });
}
