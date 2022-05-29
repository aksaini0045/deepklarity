class Product {
  int productid;
  String productName;
  String productUrl;
  String productRating;
  String productDiscription;

  Product(
      {required this.productid,
      required this.productName,
      required this.productUrl,
      required this.productRating,
      required this.productDiscription});

  factory Product.fromJson(Map<String, dynamic> jsondata) => Product(
        productid: jsondata['productId'],
        productName: jsondata['productName'],
        productUrl: jsondata['productUrl'],
        productRating: jsondata['productRating'],
        productDiscription: jsondata['productDiscription'],
      );
  Map<String, dynamic> toJson() => {
        'productid': productid,
        'productname': productName,
        'producturl': productUrl,
        'productrating': productRating,
        'productdiscription': productDiscription,
      };
}
