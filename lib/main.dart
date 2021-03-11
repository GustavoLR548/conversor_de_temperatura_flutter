import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  double temperature;
  double result;
  int precision;

  String convertedValue;

  Map<String, bool> selectedOperation = {};
  Map<String, String> abreviation = {};

  void initState() {
    temperature = 0;
    result = 273.15;
    precision = 0;
    convertedValue = 'K';

    selectedOperation = {
      'Kelvin': true,
      'Fahrenheit': false,
      'Reaumer': false,
      'Rankine': false
    };

    abreviation = {
      'Kelvin': 'K',
      'Fahrenheit': 'F',
      'Reaumer': 'r',
      'Rankine': 'Ra'
    };

    super.initState();
  }

  _submit() {
    final allFormsAreValid = _formKey.currentState.validate();

    if (allFormsAreValid) {
      _formKey.currentState.save();

      var key = selectedOperation.keys
          .firstWhere((element) => selectedOperation[element]);

      convertedValue = abreviation[key];

      setState(() {
        if (key.contains('Kelvin')) {
          result = temperature + 273.15;
        } else if (key.contains('Fahrenheit')) {
          result = (temperature * 9 / 5) + 32;
        } else if (key.contains('Reaumer')) {
          result = temperature - (temperature / 5);
        } else {
          result = (temperature + 273.15) * 9 / 5;
        }
      });
    }
  }

  _changeOperation(bool newValue, String title) {
    if (selectedOperation[title] != true)
      setState(() {
        selectedOperation.forEach((key, value) {
          if (key == title)
            selectedOperation[key] = newValue;
          else
            selectedOperation[key] = !newValue;
        });
      });
  }

  Widget _buildCheckboxListTile(String title, bool value) {
    return CheckboxListTile(
        key: Key(title),
        title: Text(title),
        value: value,
        onChanged: (value) => _changeOperation(value, title));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> checkboxes = [];

    setState(() {
      selectedOperation.forEach((key, value) {
        checkboxes.add(_buildCheckboxListTile(key, value));
      });
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('Conversor de temperatura'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(

            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Text('Escolha a unidade de base'),
                  ...checkboxes,
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Configure a precisão'),
                  Slider(
                    value: precision.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        precision = value.round();
                      });
                    },
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: '$precision',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: temperature.toString(),
                    decoration: InputDecoration(labelText: 'Celsius'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      temperature = double.parse(value);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'A temperatura não pode ser vazia';
                      }

                      if (double.tryParse(value) == null) {
                        return 'Digite um número';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      child: const Text('Calcular'),
                      onPressed: _submit,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor))),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Card(
                      child: const Text(
                        'Resultado: ${result.toStringAsFixed(precision)} °' +
                            convertedValue,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
