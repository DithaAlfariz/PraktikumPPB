import 'package:flutter/material.dart';
import 'hewan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Hewan Anjing = Hewan('Guguk', 5);

  void makan(){
    setState(() {
      Anjing.berat += 1;
    });
  }
  
  void lari(){
    setState(() {
      Anjing.berat -= 0.5;
    });
  }
  @override
  Widget build(BuildContext context) {
    // String SedangMakan = kucing1.makan(kucing1, 200);
    String info = 'Berat ${Anjing.nama} sekarang adalah ${Anjing.berat} kg.';
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Latihan'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // SedangMakan + '\n\n' +
                info,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: makan,
                child: Text('Makan'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: lari,
                child: Text('Lari'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}