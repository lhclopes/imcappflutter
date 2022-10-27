import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMC',
      theme: ThemeData(
        backgroundColor: Colors.grey,
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'IMC App Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class People {
  final String name;
  final double weight;
  final double height;

  People(this.name, this.weight, this.height);
}

class _MyHomePageState extends State<MyHomePage> {
  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  var heightFormatter = MaskTextInputFormatter(
      mask: '#.##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  _calculate(People people) {
    double imc = people.weight / (people.height * people.height);

    if (imc < 16) {
      return "Magreza Grave(${imc.toStringAsPrecision(3)})";
    } else if (imc < 17) {
      return "Magreza Moderada(${imc.toStringAsPrecision(3)})";
    } else if (imc < 18.5) {
      return "Magreza Leve (${imc.toStringAsPrecision(3)})";
    } else if (imc < 25) {
      return "Saudavel(${imc.toStringAsPrecision(3)})";
    } else if (imc < 30) {
      return "Sobrepeso(${imc.toStringAsPrecision(3)})";
    } else if (imc < 35) {
      return "Obesidade Grau I(${imc.toStringAsPrecision(3)})";
    } else if (imc < 39.9) {
      return "Obesidade Grau II(${imc.toStringAsPrecision(3)})";
    } else if (imc >= 40) {
      return "Obesidade Grau III(${imc.toStringAsPrecision(3)})";
    }
  }

  _displayDialog(BuildContext context, String name, String msg) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(name, textAlign: TextAlign.center),
              content: Text(
                msg,
                textAlign: TextAlign.center,
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Place your personal information, and click then Calculate!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 18,
                height: 2,
              ),
            ),
            _form()
          ],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Widget _form() {
    return Form(
        key: _formKey,
        child: Container(
            margin: const EdgeInsets.all(50.0), // Or set whatever you want
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin:
                        const EdgeInsets.all(10.0), // Or set whatever you want
                    child: TextFormField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name',
                      ),
                      maxLength: 40,
                      controller: nameController,
                    )),
                Container(
                    margin:
                        const EdgeInsets.all(10.0), // Or set whatever you want
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Weight',
                      ),
                      keyboardType: TextInputType.number,
                      controller: weightController,
                    )),
                Container(
                    margin:
                        const EdgeInsets.all(10.0), // Or set whatever you want
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Height',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: heightController,
                      inputFormatters: [heightFormatter],
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.greenAccent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(320, 50),
                    ),
                    onPressed: () {
                      double weight = double.parse(weightController.text);
                      double height = double.parse(heightController.text);

                      if (_formKey.currentState!.validate()) {
                        People people =
                            People(nameController.text, weight, height);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );

                        _displayDialog(
                            context, people.name, _calculate(people));
                      }
                    },
                    child: const Text('Calculate'),
                  ),
                ),
              ],
            )));
  }
}
