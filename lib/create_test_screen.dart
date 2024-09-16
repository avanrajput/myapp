import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'test_model.dart';

class CreateTestScreen extends StatefulWidget {
  const CreateTestScreen({super.key});

  @override
  State<CreateTestScreen> createState() => _CreateTestScreenState();
}

class _CreateTestScreenState extends State<CreateTestScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  int _numQuestions = 10;
  final int _totalTime = 1800; // 30 minutes in seconds

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Test Title
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Test Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter test title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              const SizedBox(height: 20),
              // Test Description
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Test Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              // Number of Questions
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Number of Questions',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: '10',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of questions';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _numQuestions = int.parse(value!);
                },
              ),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Test newTest = Test(
                      title: _title,
                      description: _description,
                      numQuestions: _numQuestions,
                      totalTime: _totalTime,
                    );
                    Provider.of<TestModel>(context, listen: false)
                        .addTest(newTest);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
