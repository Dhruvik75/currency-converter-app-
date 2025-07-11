import 'package:flutter/material.dart';
import 'dart:async';
import "package:currency_converter_pro/currency_converter_pro.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _amountController = TextEditingController();

  String _convertedAmount = '';
  String _fromCurrency = 'usd';
  String _toCurrency = 'inr';
  final List<String> _currencies = [
    'usd',
    'inr',
    'eur',
    'gbp',
    'jpy',
    'aud',
    'cad'
  ];

  Future<void> _convertCurrency() async {
    final double amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      setState(() {
        _convertedAmount = 'Please enter a valid amount.';
      });
      return;
    }
    try {
      final CurrencyConverterPro currencyConverter = CurrencyConverterPro();
      final double? result = await currencyConverter.convertCurrency(
        amount: amount,
        fromCurrency: _fromCurrency,
        toCurrency: _toCurrency,
      );

      if (result != null) {
        setState(() {
          _convertedAmount = result.toStringAsFixed(2);
        });
      } else {
        setState(() {
          _convertedAmount = 'Conversion failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _convertedAmount = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Currency Converter'),
          backgroundColor: Colors.blue,
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Currency Converter',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _fromCurrency,
                      items: _currencies.map((String currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _fromCurrency = value ?? 'usd';
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'From Currency',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.swap_horiz, size: 30, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _toCurrency,
                      items: _currencies.map((String currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _toCurrency = value ?? 'inr';
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'To Currency',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Amount',
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.confirmation_number, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _convertCurrency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Convert Currency',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _convertedAmount.isEmpty
                    ? 'Converted Amount will appear here'
                    : 'Converted Amount: $_convertedAmount $_toCurrency',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
