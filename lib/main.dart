import 'package:deepklarity/provider/product_provider.dart';
import 'package:deepklarity/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const DeepKlarity());
}

class DeepKlarity extends StatelessWidget {
  const DeepKlarity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DeepKlarity',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Homescreen()),
    );
  }
}
