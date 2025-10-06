import 'package:flutter/material.dart';

void main() => runApp(BelajarImage());

class Berita {
  final String imageUrl;
  final String title;
  final String subtitle;

  Berita({required this.imageUrl, required this.title, required this.subtitle});
}

class BelajarImage extends StatelessWidget {
  final List<Berita> daftarBerita = [
    Berita(
      imageUrl: 'https://asset.kompas.com/crops/fXkYUxXICu-vvzMYqsUCG3MGBew=/0x0:4032x2688/1200x800/data/photo/2025/10/05/68e21ed59abb5.jpg',
      title: 'Bangunan Mushola Ambruk',
      subtitle: 'Kemenag Akan Undang Kiai hingga Pengasuh Ponpes Bahas Standar Pembangunan Pesantren.',
    ),
    Berita(
      imageUrl: 'https://asset.kompas.com/crops/b5rE4WqMThEU6Mll5GxeX19cArY=/0x0:4999x3333/1200x800/data/photo/2025/10/04/68e08a3c0240b.jpg',
      title: 'Menjelang HUT TNI ke-80',
      subtitle: 'Menanti 133.000 Prajurit Unjuk Gigi dalam HUT Ke-80 TNI, Terbesar Sepanjang Sejarah.',
    ),
    Berita(
      imageUrl: 'https://akcdn.detik.net.id/visual/2025/05/27/dakwaan-kasus-dugaan-korupsi-investasi-fiktif-pt-taspen-ta-2019-1748331216181_169.jpeg?w=650&q=90',
      title: 'Korupsi Taspen',
      subtitle: 'Kasus Korupsi Taspen, Eks Dirut PT IIM Divonis 9 Tahun Penjara.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Daftar Berita / Artikel'),
        ),
        body: ListView.builder(
          itemCount: daftarBerita.length,
          itemBuilder: (context, index) {
            final berita = daftarBerita[index];
            return ListTile(
              leading: Image.network(
                berita.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
              title: Text(berita.title),
              subtitle: Text(berita.subtitle),
              trailing: Icon(Icons.bookmark_border),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mengalihkan ke halaman berita')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}