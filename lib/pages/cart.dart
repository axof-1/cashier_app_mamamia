import 'package:material_ui/material_ui.dart';

import '../utils/format.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // data dummy keranjang
  final List<CartItem> _items = [
    CartItem(product: dummyProducts[0], quantity: 0),
    CartItem(product: dummyProducts[1], quantity: 0),
    CartItem(product: dummyProducts[2], quantity: 0),
    CartItem(product: dummyProducts[3], quantity: 0),
  ];

  int get _jumlahPesanan {
    int total = 0;
    for (final item in _items) {
      total += item.quantity;
    }
    return total;
  }

  int get _subtotal {
    int total = 0;
    for (final item in _items) {
      total += item.product.productPrice * item.quantity;
    }
    return total;
  }

  int get _pajak => (_subtotal * 0.11).round();
  int get _diskon => 0;
  int get _estimasiTagihan => _subtotal + _pajak - _diskon;
  final TextEditingController _searchController = TextEditingController();
  String _kataKunci = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CartItem> get _itemTampil {
    return _items
        .where(
          (item) => item.product.productName.toLowerCase().contains(
            _kataKunci.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final tampil = _itemTampil;
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pesanan')),
      body: _items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64),
                  SizedBox(height: 12),
                  Text('Keranjang kosong'),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Cari pesanan',
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
                ),
                Expanded(
                  child:
                      tampil
                          .isEmpty // ① ternary baru
                      ? const Center(child: Text('Pesanan tidak ditemukan'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12.0),
                          itemCount: tampil.length,
                          itemBuilder: (context, index) {
                            final item = tampil[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // 1. gambar kecil
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        item.product.productImage,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // 2. nama dan harga (mengisi sisa lebar)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.product.productName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            formatRupiah(
                                              item.product.productPrice,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // 3. kontrol kuantitas
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (item.quantity > 0) {
                                            item.quantity--;
                                          } else {
                                            _items.remove(item);
                                          }
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                    ),
                                    Text('${item.quantity}'),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          item.quantity++;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Column(
                    children: [
                      _baris('Jumlah pesanan', '$_jumlahPesanan'),
                      _baris('Subtotal', formatRupiah(_subtotal)),
                      _baris('Pajak (11%)', formatRupiah(_pajak)),
                      _baris('Diskon', formatRupiah(_diskon)),
                      const Divider(),
                      _baris(
                        'Estimasi Tagihan',
                        formatRupiah(_estimasiTagihan),
                        tebal: true,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Lanjut ke Pembayaran'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _baris(String label, String nilai, {bool tebal = false}) {
    final gaya = TextStyle(
      fontWeight: tebal ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: gaya),
          Text(nilai, style: gaya),
        ],
      ),
    );
  }
}
