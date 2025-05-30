import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Main entry point of the app
void main() => runApp(const TemperatureConverterApp());

// Root widget of the application
class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up MaterialApp with theme and home page
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const TemperatureConverter(),
    );
  }
}

// Stateful widget for the temperature converter UI
class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({super.key});

  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

// State class for TemperatureConverter
class _TemperatureConverterState extends State<TemperatureConverter> {
  // Controller for the input TextField
  final TextEditingController _controller = TextEditingController();
  // List to store conversion history
  final List<String> _history = [];
  // Boolean to track conversion direction (true: F to C, false: C to F)
  bool _isFtoC = true;
  // String to store the converted value
  String _converted = '';

  // Method to perform temperature conversion and update history
  void _convert() {
    double? input = double.tryParse(_controller.text);
    if (input == null) return;

    double result;
    String historyEntry;
    if (_isFtoC) {
      // Fahrenheit to Celsius conversion
      result = (input - 32) * 5 / 9;
      historyEntry =
          '🌡️ ${input.toStringAsFixed(1)}°F ➔ ${result.toStringAsFixed(2)}°C';
    } else {
      // Celsius to Fahrenheit conversion
      result = input * 9 / 5 + 32;
      historyEntry =
          '🌡️ ${input.toStringAsFixed(1)}°C ➔ ${result.toStringAsFixed(2)}°F';
    }

    setState(() {
      _converted = result.toStringAsFixed(2);
      _history.insert(0, historyEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check device orientation for responsive layout
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌡️ Temperature Converter'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: isLandscape ? _buildLandscapeLayout() : _buildPortraitLayout(),
      ),
    );
  }

  // Build layout for portrait orientation
  Widget _buildPortraitLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._buildInputWidgets(),
          const SizedBox(height: 20),
          _buildHistorySection(),
        ],
      ),
    );
  }

  // Build layout for landscape orientation
  Widget _buildLandscapeLayout() {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ..._buildInputWidgets(),
                const SizedBox(height: 20),
                _buildHistorySection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build widgets for input section (conversion type, input field, button)
  List<Widget> _buildInputWidgets() {
    return [
      const Text(
        'Choose conversion type:',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      const SizedBox(height: 8),
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            // Radio button for Fahrenheit to Celsius
            RadioListTile<bool>(
              title: const Text('Fahrenheit to Celsius'),
              value: true,
              groupValue: _isFtoC,
              onChanged: (val) => setState(() => _isFtoC = val!),
            ),
            // Radio button for Celsius to Fahrenheit
            RadioListTile<bool>(
              title: const Text('Celsius to Fahrenheit'),
              value: false,
              groupValue: _isFtoC,
              onChanged: (val) => setState(() => _isFtoC = val!),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          // Input field for temperature value
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter temperature',
                prefixIcon: Icon(Icons.thermostat),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Display converted value
          Text(
            '= $_converted°',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 20),
      // Convert button
      SizedBox(
        height: 48,
        child: ElevatedButton.icon(
          onPressed: _convert,
          icon: const Icon(Icons.swap_horiz),
          label: const Text('CONVERT'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    ];
  }

  // Build the conversion history section
  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Conversion History',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Divider(),
        Container(
          height: 300, // Fixed height for history section
          child:
              _history.isEmpty
                  ? const Center(
                    child: Text(
                      'No history yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(_history[index]),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
