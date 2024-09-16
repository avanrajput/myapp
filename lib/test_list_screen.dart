import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'test_model.dart';
import 'test_screen.dart';
import 'create_test_screen.dart';

class TestListScreen extends StatelessWidget {
  const TestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testModel = Provider.of<TestModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OMR Tests'),
      ),
      body: testModel.tests.isEmpty
          ? const Center(
              child: Text(
                'No tests available. Create one!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: testModel.tests.length,
              itemBuilder: (context, index) {
                final test = testModel.tests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    title: Text(test.title),
                    subtitle: Text(test.description),
                    trailing: const Icon(Icons.play_arrow),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestScreen(index: index),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTestScreen(),
            ),
          );
        },
        tooltip: 'Create Test',
        child: const Icon(Icons.add),
      ),
    );
  }
}
