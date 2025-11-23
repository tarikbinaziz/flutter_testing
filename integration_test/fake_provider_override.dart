// integration_test/fake_provider_override.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_testing_all/features/auth/controllers/auth_controller.dart';
import 'package:flutter_testing_all/features/auth/data/repositories/auth_repository_fake.dart';

final testContainer = ProviderContainer(overrides: [
  authRepositoryProvider.overrideWithValue(AuthRepositoryFake()),
  authControllerProvider.overrideWith((ref) {
    final repo = ref.watch(authRepositoryProvider);
    return AuthController(repo);
  }),
]);
