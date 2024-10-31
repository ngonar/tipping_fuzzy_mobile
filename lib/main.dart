import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tipping_fuzzy/tip_response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tipping Fuzzy',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tipping Fuzzy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _tip = '';
  double _foodValue = 3;
  double _serviceValue = 3;
  final  _amountController = TextEditingController();

  void _setTip(tipValue) {
    setState(() {
      _tip =  tipValue;
    });
  }

  void _setAmount(billAmount) {
    setState(() {
      _amountController.text = billAmount;
    });
  }

  Future<TipResponse> getTip(billAmount, foodQuality, serviceQuality)  async {
    print("bill amount : "+billAmount+"food quality : "+foodQuality.toString()+", service quality : "+serviceQuality.toString());

    final response = await http.get(Uri.parse('http://ngonar.com:8000/tip/'+billAmount+'/'+foodQuality.toString()+'/'+serviceQuality.toString()));

    if (response.statusCode == 200) {
      print(response.body);
      final parsed = (jsonDecode(response.body));
      TipResponse tipResponse = TipResponse.fromJson(parsed);
      _setTip(parsed['tip'].toString());

      return tipResponse;
    }
    else {
      throw Exception("Failed to get the tip recommendation");
    }
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child:
              TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Bill Amount',
                  )
                ),
            ),
            Text(" "),
            Text("Food Quality"),
            Slider(
              value: _foodValue,
              max:5,
              divisions: 5,
              label: _foodValue.round().toString(),
              onChanged: (double value){
                setState(() {
                  _foodValue = value;
                });
              },
            ),
            Text("Service Quality"),
            Slider(
              value: _serviceValue,
              max:5,
              divisions: 5,
              label: _serviceValue.round().toString(),
              onChanged: (double value){
                setState(() {
                  _serviceValue = value;
                });
              },
            ),
            ElevatedButton(
                onPressed: (){
                  Future<TipResponse> tipResponse = getTip(_amountController.value.text, _foodValue, _serviceValue);

                  _setAmount(_amountController.value.text);
                },
                child: Text("Calculate")),
            const Text(
              'The tip amount is ',
            ),
            Text(
              _tip,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



}
