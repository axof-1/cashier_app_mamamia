import 'package:material_ui/material_ui.dart'; // samakan dengan file lain

import '../pages/cart.dart';
import '../models/product.dart';
import '../utils/format.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    required this.quantity,
    required this.onRemove,
  });

  final Product product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

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
                // 3. Row: harga, tombol −, jumlah, tombol +.
                Row(
                  children: [
                    Expanded(child: Text(formatRupiah(product.productPrice))),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: quantity > 0 ? onRemove : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$quantity'),
                    IconButton(
                      visualDensity: VisualDensity.compact,
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
  final Map<int, int> _jumlah = {};

  int get _jumlahKeranjang {
    int total = 0;
    for (final p in dummyProducts) {
      total += _jumlah[p.productId] ?? 0;
    }
    return total;
  }

  int get _totalHarga {
    int total = 0;
    for (final p in dummyProducts) {
      total += (_jumlah[p.productId] ?? 0) * p.productPrice;
    }
    return total;
  }

  final TextEditingController _searchController = TextEditingController();
  String _kataKunci = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _produkTampil {
    return dummyProducts
        .where(
          (p) => p.productName.toLowerCase().contains(_kataKunci.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasir (Katalog Pemesanan)')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cari produk',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _kataKunci = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final produk = _produkTampil;
                  final kolom = (constraints.maxWidth ~/ 200)
                      .clamp(2, 6)
                      .toInt();
                  if (produk.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('Produk tidak ditemukan'),
                        ],
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 90),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: kolom,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: produk.length,
                    itemBuilder: (context, index) {
                      final p = produk[index];
                      return ProductCard(
                        product: p,
                        quantity: _jumlah[p.productId] ?? 0,
                        onAdd: () {
                          setState(() {
                            _jumlah[p.productId] =
                                (_jumlah[p.productId] ?? 0) + 1;
                          });
                        },
                        onRemove: () {
                          setState(() {
                            _jumlah[p.productId] =
                                (_jumlah[p.productId] ?? 0) - 1;
                            if (_jumlah[p.productId] == 0) {
                              _jumlah.remove(p.productId);
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: Material(
            color: Colors.indigo.shade700,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_basket, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_jumlahKeranjang Item',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total: ${formatRupiah(_totalHarga)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
