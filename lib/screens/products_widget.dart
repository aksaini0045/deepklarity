import 'package:cached_network_image/cached_network_image.dart';
import 'package:deepklarity/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../model/productmodel.dart';

class Productswidget extends StatefulWidget {
  const Productswidget({
    Key? key,
  }) : super(key: key);

  @override
  State<Productswidget> createState() => _ProductswidgetState();
}

class _ProductswidgetState extends State<Productswidget> {
  int _lastproductid = 101;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      _getmorequestions();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _moreproductsleft = false;
  bool _acceptingrequest =
      true;
  _getmorequestions() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        _acceptingrequest) {
      _acceptingrequest = false;

      setState(() {
        _moreproductsleft = true;
      });

      await Provider.of<ProductProvider>(context, listen: false)
          .loadproducts(lastproductid: _lastproductid)
          .then((_) {
        _acceptingrequest = true;
        if (mounted) {
          setState(() {
            _moreproductsleft = false;
          });
        }
      }).onError((error, stackTrace) {
        _acceptingrequest = true;
        if (mounted) {
          setState(() {
            _moreproductsleft = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          Consumer<ProductProvider>(builder: (context, productProvider, child) {
        _lastproductid = productProvider.productslist.last.productid + 1;
        return productProvider.productslist.isEmpty
            ? const Center(
                child: Text('No Products Available'),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      cacheExtent: 9999,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if (index == productProvider.productslist.length) {
                          if (_moreproductsleft) {
                            return SpinKitWave(
                              color: Theme.of(context).colorScheme.primary,
                              type: SpinKitWaveType.start,
                              size: 40,
                            );
                          } else {
                            return const SizedBox();
                          }
                        }
                        return _singleproductwidget(
                            product: productProvider.productslist[index]);
                      },
                      itemCount: productProvider.productslist.length + 1,
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget _singleproductwidget({required Product product}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: SizedBox(
        height: 340,
        child: Card(
          color: Colors.grey.shade200,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    imageUrl: product.productUrl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            Image.asset('assets/loadinggif.gif'),
                    errorWidget: (context, url, error) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.error,
                          size: 50,
                          color: Colors.red,
                        ),
                        SizedBox(height: 8),
                        Text('Image Not Found')
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  thickness: 1,
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.productName,
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        'Rating ${product.productRating}/5',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Discription:   ${product.productDiscription}',
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
