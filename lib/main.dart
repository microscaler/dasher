import 'proxy_ffi.dart' as ffi;
import 'package:web_ffi/web_ffi.dart';
import 'package:web_ffi/web_ffi_modules.dart';
import 'package:dasher/bridge_generated.dart';
import 'package:flutter/material.dart';
// import 'package:platform/platform.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

const base = "rust";
const libpath = "lib$base.so";
late final dylib = DynamicLibrary.open(libpath);
late final ffibridge = RustImpl(dylib);


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  late Future<int> counter;

  @override
  void initState() {
    super.initState();
    counter = ffibridge.getCounter();
  }

  void _incrementCounter() {
    setState(() {
      counter = ffibridge.increment();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            FutureBuilder(future: Future.wait([counter]), builder: (context, snap) {
              final data = snap.data;
              if (data == null) {
                return const Text("Loading");
              }
              return Text(
                '${data[0]}',
                style: Theme.of(context).textTheme.headline4,
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
