import 'package:material_ui/material_ui.dart'; // samakan dengan file lain

import '../pages/cart.dart';
import '../models/product.dart';
import '../utils/format.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onAdd});

  final Product product;
  final VoidCallback onAdd; // fungsi tanpa parameter dan tanpa hasil

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // memotong gambar mengikuti sudut card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. gambar produk: mengisi sisa tinggi card
          Expanded(
            child: Image.asset(
              product.productImage,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. nama produk
                Text(
                  product.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // 3. Row: harga di kiri, tombol + di kanan (spaceBetween)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatRupiah(product.productPrice)),
                    IconButton(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add_circle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  int _jumlahKeranjang = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasir (Katalog Pemesanan)')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final kolom = constraints.maxWidth > 600
                ? 4
                : 2; // lebar kolom minimal 200px
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: kolom,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: dummyProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: dummyProducts[index],
                  onAdd: () {
                    setState(() {
                      _jumlahKeranjang++;
                    });
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigasi ke halaman keranjang
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
        },
        child: Badge(
          label: Text('$_jumlahKeranjang'),
          child: const Icon(Icons.shopping_basket),
        ),
      ),
    );
  }
}
