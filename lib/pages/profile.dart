import 'package:material_ui/material_ui.dart';

import 'catalog.dart';

// 1. Data satu menu: judul, ikon, dan warna
class MenuKasir {
  final String judul;
  final IconData ikon;
  final MaterialColor warna;

  const MenuKasir(this.judul, this.ikon, this.warna);
}

// 2. Daftar menu (dummy)
const List<MenuKasir> daftarMenu = [
  MenuKasir('Kasir (Katalog Pemesanan)', Icons.point_of_sale, Colors.green),
  MenuKasir('Produk', Icons.inventory_2, Colors.orange),
  MenuKasir('Stok', Icons.inventory, Colors.brown),
  MenuKasir('Pelanggan', Icons.people, Colors.blue),
  MenuKasir('Laporan', Icons.bar_chart, Colors.purple),
  MenuKasir('Riwayat', Icons.receipt_long, Colors.teal),
  MenuKasir('Diskon', Icons.local_offer, Colors.red),
  MenuKasir('Pengaturan', Icons.settings, Colors.blueGrey),
];

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Page')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Selamat Datang', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 14),
              // 1. avatar
              const CircleAvatar(
                radius: 48,
                child: Icon(Icons.person, size: 48),
              ),
              // 2. SizedBox
              const SizedBox(height: 16),
              // 3. Text email
              Text(
                email,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // 4. SizedBox
              const SizedBox(height: 24),
              // 5. grid menu kasir (dummy)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  for (final menu in daftarMenu) _MenuTile(menu: menu),
                ],
              ),
              // 6. SizedBox
              const SizedBox(height: 24),
              // 7. tombol Logout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  onPressed: () {
                    // Lakukan proses logout di sini
                    Navigator.pop(context); // Kembali ke halaman login
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. Satu kotak menu
class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.menu});

  final MenuKasir menu;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: menu.warna.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: menu.warna.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (menu.judul == 'Kasir (Katalog Pemesanan)') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CatalogPage()),
            );
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Menu ${menu.judul} belum tersedia (dummy)'),
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(menu.ikon, size: 36, color: menu.warna.shade700),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                menu.judul,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
