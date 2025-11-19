import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_flow/models/user_model.dart';
import 'package:flutter_test_flow/unit_test/repository_layer/user_repository.dart';
import 'package:flutter_test_flow/unit_test/riverpod/controllers/user_controller_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late ProviderContainer container;
  late MockUserRepository mockRepo;

  setUp(() {
    mockRepo = MockUserRepository();

    container = ProviderContainer(overrides: [
      userRepositoryProvider.overrideWithValue(mockRepo),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  test("initial state is correct", () {
    final state = container.read(userControllerProvider);
    expect(state.loading, false);
    expect(state.user, null);
    expect(state.error, null);
  });

  test("fetchUser → success state", () async {
    final mockUser = UserModel(
      id: 1,
      name: "tarik",
      email: "e@e.com",
      balance: 100,
    );

    when(() => mockRepo.getUser()).thenAnswer((_) async => mockUser);

    final controller = container.read(userControllerProvider.notifier);

    // Start
    final future = controller.fetchUser();

    // Should be loading
    expect(container.read(userControllerProvider).loading, true);

    await future;

    final state = container.read(userControllerProvider);

    expect(state.loading, false);
    expect(state.user, mockUser);
    expect(state.error, null);
  });

  test("fetchUser → error state", () async {
    when(() => mockRepo.getUser()).thenThrow(Exception("Network failed"));

    final controller = container.read(userControllerProvider.notifier);

    await controller.fetchUser();

    final state = container.read(userControllerProvider);

    expect(state.loading, false);
    expect(state.error, contains("Network failed"));
    expect(state.user, null);
  });
}
