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
  String fLength = '';
  String fWidth = '';
  String fSize = '';
  String fConc = '';

  var data;
  String output = '';

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
              child: Column(children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Enter fLength"),
                  onSaved: (newValue) {
                    fLength = newValue.toString();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Enter fWidth"),
                  onSaved: (newValue) {
                    fWidth = newValue.toString();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Enter fSize"),
                  onSaved: (newValue) {
                    fSize = newValue.toString();
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Enter fConc"),
                  onSaved: (newValue) {
                    fConc = newValue.toString();
                  },
                ),
                TextButton(
                    onPressed: () async {
                      savingForm();

                      const url = 'http://10.0.2.2:5000/predict';
                      data = await http.post(Uri.parse(url),
                          body: json.encode({
                            'fLength': fLength,
                            'fWidth': fWidth,
                            'fSize': fSize,
                            'fConc': fConc
                          }));

                      print('Data is ${json.decode(data.body)}');
                    },
                    child: const Text('Submit')),
              ])),
        ),
      ),
    );
  }
}
