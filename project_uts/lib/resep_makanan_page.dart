import 'package:flutter/material.dart';
import 'navbar.dart';
import 'data_makanan.dart';
import 'resep_minuman_page.dart';
import 'resep_cemilan_page.dart';
import 'resep_kue_page.dart';
import 'tambah_resep_page.dart';
import 'detail_resep_page.dart';

class ResepMakananPage extends StatefulWidget {
  const ResepMakananPage({super.key});

  @override
  State<ResepMakananPage> createState() => _ResepMakananPageState();
}

class _ResepMakananPageState extends State<ResepMakananPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> resepList = [];

  @override
  void initState() {
    super.initState();
    _loadResep();
  }

  Future<void> _loadResep() async {
    final list = await ResepDataMakanan.getResepList();
    setState(() {
      resepList = list.isEmpty ? [] : list;
    });
  }

  Future<void> _saveResep() async {
    await ResepDataMakanan.saveResepList(resepList);
  }

  void _hapusResep(int index) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus resep ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi == true) {
      setState(() {
        resepList.removeAt(index);
      });
      await _saveResep();
    }
  }

  void _toggleFavorit(int index) async {
    setState(() {
      resepList[index]['favorit'] = !resepList[index]['favorit'];
      if (resepList[index]['favorit']) {
        final favoritResep = resepList.removeAt(index);
        resepList.insert(0, favoritResep);
      }
    });
    await _saveResep();
  }

  void _onNavTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResepCemilanPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResepMinumanPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResepKuePage()),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _tambahResep() async {
    final hasil = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const TambahResepPage()),
    );
    if (hasil != null) {
      setState(() {
        resepList.add(hasil);
      });
      await _saveResep();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Makanan'),
      ),
      body: resepList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada resep makanan.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: resepList.length,
              itemBuilder: (context, index) {
                final resep = resepList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailResepPage(resep: resep),
                        ),
                      );
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        resep['gambar'],
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.fastfood),
                      ),
                    ),
                    title: Text(resep['nama']),
                    subtitle: Text(resep['ringkasan']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            resep['favorit'] ? Icons.favorite : Icons.favorite_border,
                            color: resep['favorit'] ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorit(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _hapusResep(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahResep,
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}