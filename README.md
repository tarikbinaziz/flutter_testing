# flutter_testing_all

# flutter_test_flow

A new Flutter project.

// code generated via build_runner
 flutter pub run build_runner build --delete-conflicting-outputs



## Getting Started

🧪 What Is a Unit Test in Flutter?
    A Unit Test checks a small piece of logic in isolation (e.g., a method, class, or function) without depending on UI or real services (like APIs or databases).

🔍 void main() { ... }
Every Dart app starts with main(). For tests, this is where you define all your test logic.

🔍 group('Calculator Test', () { ... });
Used to group multiple tests under one title. This helps organize your tests.

   group('Calculator Test', () {
        // all tests related to Calculator go here
   });

🧠 Think of it like:

"All the tests inside this group are for the Calculator class."

🔍 final calculator = Calculator();
Create an instance of the class you want to test.

.

🔍 test('should return sum of two numbers', () { ... });
test() is a function from Flutter Test package.

    First parameter: A description of what the test is doing.

    Second parameter: The actual test code.

🔍 expect(actual, matcher);
Used to assert something. If the result is not what you expected, the test fails.

    actual: what you’re testing (e.g., calculator.add(2, 3))

    matcher: what the expected output should be (e.g., 5)


🧪 Matchers You Should Know (in Unit Tests)
    Matcher	         Meaning

    equals(x)	     Equals value x
    isTrue	         Must be true
    isFalse	         Must be false
    isNull	         Must be null
    isNotNull	     Must not be null
    throwsException	 Should throw error
    contains(x)	     Must contain value x

## Provider test
ProviderContainer দিয়ে test এ Riverpod provider isolate করে test করা যায়।

setUp() এবং tearDown() দিয়ে test lifecycle clean রাখা হয়।

প্রত্যেকটি method আলাদা test block এ check করছি।

expect(container.read(toggleWidgetProvider), ...) দিয়ে state মান verify করছি।

✅ Simple Explanation:
Function	কাজ
setUp()	Test run হওয়ার আগে প্রতি test এর জন্য prepare করে।
tearDown()	Test শেষ হওয়ার পরে clean-up করে।

✅ কেন দরকার হয়:
১️⃣ যদি আপনার test code এর ভিতরে reusable initialization থাকে:
➡️ বারবার duplicate না করে, setUp() এ রাখবেন।

২️⃣ যখন resource create করতে হয় (example: ProviderContainer, mock object)
➡️ Test environment clean রাখার জন্য।

৩️⃣ যখন কোন stateful service, database, বা file open করা হয়
➡️ tearDown() দিয়ে dispose বা close করতে হবে।



# Commands summary

Run all unit & widget tests:

flutter test


Run a single test:

flutter test test/widget/login_screen_test.dart


Run integration tests:

flutter test integration_test/app_test.dart


or use flutter drive if your setup requires it.


To run your integration test correctly, you MUST follow Flutter’s integration test rules.

Here is the exact method 👇

✅ 1. Integration tests must be inside:
integration_test/


NOT:

test/integration_test/


So fix your folder:

❌ Wrong
test/integration_test/app_full_flow_test.dart

✅ Correct
integration_test/app_full_flow_test.dart


Move the file:

mkdir integration_test
mv test/integration_test/app_full_flow_test.dart integration_test/

✅ 2. Run the integration test

Use this command:

flutter test integration_test/app_full_flow_test.dart


or run all integration tests:

flutter test integration_test

❗ If running on a real device / emulator:

Use:

flutter test integration_test/app_full_flow_test.dart --dart-define=integration_test=true


OR run via:

flutter drive \
  --driver=test_driver/integration_test_driver.dart \
  --target=integration_test/app_full_flow_test.dart


(Only if you set up a driver — optional.)

🔥 Preferred modern way (no driver needed)

Just run:

flutter test integration_test


Flutter will automatically detect integration tests.

🟢 Summary
Folder	Supported	Run Command
test/	unit & widget tests	flutter test
integration_test/	integration tests	flutter test integration_test


3️⃣ Best practice

Unit test → small piece of logic (pure functions, fake repo)

Widget test → UI widgets (use fake repo to avoid network)

Integration test → end-to-end flow

Real API এর সাথে করতে চাও → ✅ সম্ভব

Stable & fast করতে → fake/mock repo use করা ভালো