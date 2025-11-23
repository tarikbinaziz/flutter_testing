✅ Step 6: Riverpod StateNotifier + Unit Test (Full Production Setup)

This is one of the MOST IMPORTANT parts of testing a Flutter app.
In this step you will learn:

✔ Create a State class
✔ Create a Riverpod StateNotifier
✔ Connect with Repository
✔ Write full unit test (loading → success → error)
✔ Override providers during testing
✔ Mock repository using mocktail

This mirrors real production architecture.

📁 Folder Structure (Recommended)
lib/
 └── unit_test/
      └── riverpod/
           ├── controllers/
           ├── states/
           ├── repositories/

Step 6.1 → Create State Class

We use immutable state.

user_state.dart
import 'package:equatable/equatable.dart';
import '../../../models/user_model.dart';

class UserState extends Equatable {
  final bool loading;
  final UserModel? user;
  final String? error;

  const UserState({
    this.loading = false,
    this.user,
    this.error,
  });

  UserState copyWith({
    bool? loading,
    UserModel? user,
    String? error,
  }) {
    return UserState(
      loading: loading ?? this.loading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [loading, user, error];
}

Step 6.2 → Create StateNotifier
user_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../states/user_state.dart';
import '../repositories/user_repository.dart';

class UserController extends StateNotifier<UserState> {
  final UserRepository repo;

  UserController(this.repo) : super(const UserState());

  Future<void> fetchUser() async {
    state = state.copyWith(loading: true, error: null);

    try {
      final user = await repo.getUser();
      state = state.copyWith(loading: false, user: user);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

Step 6.3 → Riverpod Provider
user_controller_provider.dart
final userControllerProvider =
    StateNotifierProvider<UserController, UserState>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return UserController(repo);
});


And the repository provider:

final userRepositoryProvider = Provider((ref) {
  return UserRepository(ref.read(userServiceProvider));
});

Step 6.4 → UNIT TESTING Riverpod StateNotifier

This is the REAL step.

We test:

Loading state

Success state

Error state

Repository mock

Install mocktail:

flutter pub add mocktail --dev

🧪 Step 6 — Test File
user_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_testing_all/models/user_model.dart';
import 'package:flutter_testing_all/unit_test/riverpod/controllers/user_controller.dart';
import 'package:flutter_testing_all/unit_test/riverpod/states/user_state.dart';
import 'package:flutter_testing_all/unit_test/riverpod/repositories/user_repository.dart';

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

🎉 Step 6 Complete

Now you have mastered:

✔ State class
✔ Riverpod StateNotifier
✔ Provider override
✔ Mock repository
✔ Loading → Success → Error state testing
✔ Fully testable controller

You're now ready for REAL production apps.