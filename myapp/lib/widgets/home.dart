import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();

  final fieldNames = [
    'accelerometer-x-l',
    'accelerometer-y-l',
    'accelerometer-z-l',
    'Gyro-x-l',
    'Gyro-y-l',
    'Gyro-z-l',
    'NC/SC-l'
  ];

  final fieldValues = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  var data;
  var output = "";

  Future<void> savingForm() async {
    final validation = _formKey.currentState!.validate();

    if (!validation) {
      return;
    }

    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Form(
              key: _formKey,
              child: ListView(scrollDirection: Axis.vertical, children: [
                ...List.generate(fieldNames.length, (index) {
                  return TextFormField(
                    decoration: InputDecoration(
                        labelText: "Enter ${fieldNames[index]}"),
                    onSaved: (newValue) {
                      fieldValues[index] = newValue.toString();
                    },
                  );
                }),
                TextButton(
                    onPressed: () async {
                      savingForm();
                      const url = 'http://10.0.2.2:5000/predict';
                      data = await http.post(Uri.parse(url),
                          body: json.encode({
                            fieldNames[0]: fieldValues[0],
                            fieldNames[1]: fieldValues[1],
                            fieldNames[2]: fieldValues[2],
                            fieldNames[3]: fieldValues[3],
                            fieldNames[4]: fieldValues[4],
                            fieldNames[5]: fieldValues[5],
                            fieldNames[6]: fieldValues[6],
                          }));

                      for (int i = 0; i < 7; i++) {
                        print('${fieldValues[i]} ');
                      }
                      print('Data is ${json.decode(data.body)}');

                      final decoded = json.decode(data.body);

                      setState(() {
                        output = decoded['result'] == 1
                            ? 'Parkinsons'
                            : 'No Parkinsons';
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10.0),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          ),
                    )),
                Center(
                    child: Text(
                  output.toString(),
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ))
              ])),
        ),
      ),
    );
  }
}

// TextFormField(
//                   decoration:
//                       const InputDecoration(labelText: "Enter accelometer-x-l"),
//                   onSaved: (newValue) {
//                     fLength = newValue.toString();
//                   },
//                 )