# flutter_test_flow

A new Flutter project.

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