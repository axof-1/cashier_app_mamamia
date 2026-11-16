class Product {
  final int productId;
  final String productName;
  final int productPrice;
  final String productImage;   // path asset, contoh: 'assets/images/kentang.png'

  const Product({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  });
}

// Data dummy
const List<Product> dummyProducts = [
  Product(productId: 1, productName: 'Cup Noodles', productPrice: 8000, productImage: 'assets/images/product_1_cup_noodles.png'),
  Product(productId: 2, productName: 'Instant Noodles', productPrice: 4000, productImage: 'assets/images/product_2_instant_noodles.png'),
  Product(productId: 3, productName: 'Canned Sardines', productPrice: 35000, productImage: 'assets/images/product_3_canned_sardines.png'),
  Product(productId: 4, productName: 'Corned Beef', productPrice: 45000, productImage: 'assets/images/product_4_corned_beef.png'),
];