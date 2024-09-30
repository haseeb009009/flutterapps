import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unified Calculator',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _selectedCalculator = 'none';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          OverflowBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() {
                  _selectedCalculator = 'bmi';
                }),
                child: const Text('BMI Calculator'),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  _selectedCalculator = 'tip';
                }),
                child: const Text('Tip Calculator'),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  _selectedCalculator = 'age';
                }),
                child: const Text('Age Calculator'),
              ),
            ],
          ),
          Expanded(
            child: _buildCalculator(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculator() {
    switch (_selectedCalculator) {
      case 'bmi':
        return BMICalculator();
      case 'tip':
        return TipCalculator();
      case 'age':
        return AgeCalculator();
      default:
        return const Center(child: Text('Select a calculator'));
    }
  }
}

// BMI Calculator Widget
class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _bmiResult = '';

  void _calculateBMI() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    if (weight != null && height != null && height > 0) {
      final bmi =
          weight / ((height / 100) * (height / 100)); // height in meters
      setState(() {
        _bmiResult = 'Your BMI is ${bmi.toStringAsFixed(2)}';
      });
    } else {
      setState(() {
        _bmiResult = 'Invalid input';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
          ),
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Height (cm)'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _calculateBMI,
            child: const Text('Calculate BMI'),
          ),
          const SizedBox(height: 16),
          Text(_bmiResult),
        ],
      ),
    );
  }
}

// Tip Calculator Widget
class TipCalculator extends StatefulWidget {
  const TipCalculator({super.key});

  @override
  _TipCalculatorState createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  final _billController = TextEditingController();
  final _tipController = TextEditingController();
  String _tipResult = '';

  void _calculateTip() {
    final billAmount = double.tryParse(_billController.text);
    final tipPercentage = double.tryParse(_tipController.text);
    if (billAmount != null && tipPercentage != null) {
      final tip = billAmount * (tipPercentage / 100);
      setState(() {
        _tipResult = 'Tip amount is ${tip.toStringAsFixed(2)}';
      });
    } else {
      setState(() {
        _tipResult = 'Invalid input';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _billController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Bill Amount'),
          ),
          TextField(
            controller: _tipController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Tip Percentage'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _calculateTip,
            child: const Text('Calculate Tip'),
          ),
          const SizedBox(height: 16),
          Text(_tipResult),
        ],
      ),
    );
  }
}

// Age Calculator Widget
class AgeCalculator extends StatefulWidget {
  const AgeCalculator({super.key});

  @override
  _AgeCalculatorState createState() => _AgeCalculatorState();
}

class _AgeCalculatorState extends State<AgeCalculator> {
  final _birthdateController = TextEditingController();
  String _ageResult = '';

  void _calculateAge() {
    try {
      final birthdate =
          DateFormat('yyyy-MM-dd').parse(_birthdateController.text);
      final today = DateTime.now();
      final age = today.year -
          birthdate.year -
          (today.month < birthdate.month ||
                  (today.month == birthdate.month && today.day < birthdate.day)
              ? 1
              : 0);
      setState(() {
        _ageResult = 'Your age is $age years';
      });
    } catch (e) {
      setState(() {
        _ageResult = 'Invalid date format';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _birthdateController,
            decoration: const InputDecoration(labelText: 'Birthdate (YYYY-MM-DD)'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _calculateAge,
            child: const Text('Calculate Age'),
          ),
          const SizedBox(height: 16),
          Text(_ageResult),
        ],
      ),
    );
  }
}
