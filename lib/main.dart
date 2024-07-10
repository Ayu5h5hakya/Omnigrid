import 'package:flutter/material.dart';
import 'package:omni_grid/omni_grid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Omni Grid',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Omni Grid Example'),
          ),
          body: OmniGrid(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            children: const [
              ColoredBox(color: Colors.amber),
              ColoredBox(color: Colors.red),
              ColoredBox(color: Colors.green),
              ColoredBox(color: Colors.blue),
              ColoredBox(color: Colors.greenAccent),
              ColoredBox(color: Colors.grey),
            ],
          ),
        ));
  }
}
