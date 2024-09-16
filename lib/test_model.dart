import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TestModel with ChangeNotifier {
  List<Test> _tests = [];
  bool _isPaused = false;
  int? _currentTestIndex;

  List<Test> get tests => _tests;
  bool get isPaused => _isPaused;

  TestModel() {
    loadFromLocalStorage();
  }

  void addTest(Test test) {
    _tests.add(test);
    saveToLocalStorage();
    notifyListeners();
  }

  // Pause the test and save the elapsed time
  void pauseTest(int index, int elapsedTime) {
    _tests[index].isPaused = true;
    _tests[index].elapsedTime = elapsedTime;
    saveToLocalStorage();
    notifyListeners();
  }

  // Resume the test
  void resumeTest(int index) {
    _tests[index].isPaused = false;
    saveToLocalStorage();
    notifyListeners();
  }

  // Update the answer for a specific question
  void updateAnswer(int testIndex, int questionIndex, String answer) {
    _tests[testIndex].answers[questionIndex] = answer;
    saveToLocalStorage();
    notifyListeners();
  }

  // Update the elapsed time for the test (used in the stopwatch)
  void updateElapsedTime(int testIndex, int seconds) {
    _tests[testIndex].elapsedTime = seconds;
    saveToLocalStorage();
    notifyListeners();
  }

  // Save all tests to local storage
  Future<void> saveToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> testsJson =
        _tests.map((test) => jsonEncode(test.toMap())).toList();
    await prefs.setStringList('tests', testsJson);
  }

  // Load all tests from local storage
  Future<void> loadFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? testsJson = prefs.getStringList('tests');
    if (testsJson != null) {
      _tests = testsJson
          .map((testStr) => Test.fromMap(jsonDecode(testStr)))
          .toList();
      notifyListeners();
    }
  }
}

class Test {
  String title;
  String description;
  int numQuestions;
  int totalTime; // total time allotted for test (can be ignored if stopwatch only)
  List<String?> answers;
  int elapsedTime; // time spent on the test
  bool isPaused;
  bool completed;

  Test({
    required this.title,
    required this.description,
    required this.numQuestions,
    required this.totalTime,
    List<String?>? answers,
    this.elapsedTime = 0,
    this.isPaused = false,
    this.completed = false,
  })  : answers = answers ?? List.filled(numQuestions, null);

  // Convert the test to a Map (for saving)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'numQuestions': numQuestions,
      'totalTime': totalTime,
      'answers': answers,
      'elapsedTime': elapsedTime,
      'isPaused': isPaused,
      'completed': completed,
    };
  }

  // Factory to create a Test from a Map (for loading)
  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(
      title: map['title'],
      description: map['description'],
      numQuestions: map['numQuestions'],
      totalTime: map['totalTime'],
      answers: List<String?>.from(map['answers']),
      elapsedTime: map['elapsedTime'],
      isPaused: map['isPaused'],
      completed: map['completed'],
    );
  }
}
