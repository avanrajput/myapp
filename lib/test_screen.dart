import 'package:flutter/material.dart';
import 'package:myapp/magic_card.dart';
import 'package:provider/provider.dart';
import 'test_model.dart';
import 'dart:async';

class TestScreen extends StatefulWidget {
  final int index;

  const TestScreen({super.key, required this.index});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late Test currentTest;
  Timer? _stopwatch;
  int _elapsedTime = 0; // Elapsed time in seconds

  @override
  void initState() {
    super.initState();
    final testModel = Provider.of<TestModel>(context, listen: false);
    currentTest = testModel.tests[widget.index];
    _elapsedTime = currentTest.elapsedTime;
    _startStopwatch();
  }

  void _startStopwatch() {
    if (currentTest.completed) return;

    _stopwatch = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
      Provider.of<TestModel>(context, listen: false)
          .updateElapsedTime(widget.index, _elapsedTime);
    });
  }

  void _pauseStopwatch() {
    _stopwatch?.cancel();
    Provider.of<TestModel>(context, listen: false)
        .pauseTest(widget.index, _elapsedTime);
  }

  void _resumeStopwatch() {
    _startStopwatch();
    Provider.of<TestModel>(context, listen: false).resumeTest(widget.index);
  }

  void _completeTest() {
    _stopwatch?.cancel();
    Provider.of<TestModel>(context, listen: false)
        .tests[widget.index]
        .completed = true;
    Provider.of<TestModel>(context, listen: false).saveToLocalStorage();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Test Completed'),
        content: const Text('You have completed the test.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to test list
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stopwatch?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final testModel = Provider.of<TestModel>(context);
    currentTest = testModel.tests[widget.index];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTest.title),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(testModel.isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: () {
              if (testModel.isPaused) {
                _resumeStopwatch();
              } else {
                _pauseStopwatch();
              }
            },
            tooltip: testModel.isPaused ? 'Resume' : 'Pause',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stopwatch Display
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.deepPurpleAccent,
            ),
            width: double.infinity,
            child: Text(
              'Elapsed Time: ${_formatTime(_elapsedTime)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Questions List
          Expanded(
            child: ListView.builder(
              itemCount: currentTest.numQuestions,
              itemBuilder: (context, qIndex) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: CustomCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question Number
                          Text(
                            'Q${qIndex + 1}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Answer Options
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: ['A', 'B', 'C', 'D'].map((option) {
                              bool isSelected =
                                  currentTest.answers[qIndex] == option;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    testModel.updateAnswer(
                                        widget.index, qIndex, option);
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Complete Test Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12.0), // Less circular corners
                ),
                minimumSize:
                    const Size(double.infinity, 50), // Make the button wide
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0), // Adjust padding
                elevation: 6, // Optional: Add shadow for depth
              ),
              onPressed: _completeTest,
              child: const Text(
                'Complete Test',
                style: TextStyle(
                  fontSize: 18, // Increase font size
                  fontWeight: FontWeight.bold, // Make text bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
