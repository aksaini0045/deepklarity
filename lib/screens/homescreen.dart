import 'package:deepklarity/database/database.dart';
import 'package:deepklarity/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool _isloading = false;

  void _loaddataandnavigate() async {
    setState(() {
      _isloading = true;
    });
    await ProductsDatabase.instance.insertallproducts().then((_) async {
      await Provider.of<ProductProvider>(context, listen: false)
          .loadproducts(lastproductid: 1)
          .then((result) {
        if (result) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProductsScreen()));
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unable to Load Products')));
        }
        setState(() {
          _isloading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Klarity'),
      ),
      body: Center(
        child: _isloading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Loading Products')
                  ],
                ),
              )
            : SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)))),
                    onPressed: _loaddataandnavigate,
                    child: const Text('Load Products')),
              ),
      ),
    );
  }
}
