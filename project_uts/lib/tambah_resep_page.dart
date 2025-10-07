import 'package:flutter/material.dart';

class TambahResepPage extends StatefulWidget {
  const TambahResepPage({super.key});

  @override
  State<TambahResepPage> createState() => _TambahResepPageState();
}

class _TambahResepPageState extends State<TambahResepPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _ringkasanController = TextEditingController();
  final _gambarController = TextEditingController();
  final _caraMasakController = TextEditingController();
  bool _gambarValid = true;

  @override
  void dispose() {
    _namaController.dispose();
    _ringkasanController.dispose();
    _gambarController.dispose();
    _caraMasakController.dispose();
    super.dispose();
  }

  void _cekGambarValid(String url) {
    if (url.isEmpty) {
      setState(() {
        _gambarValid = true;
      });
      return;
    }
    
    Image.network(
      url,
    ).image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, _) {
          setState(() {
            _gambarValid = true;
          });
        },
        onError: (error, _) {
          setState(() {
            _gambarValid = false;
          });
        },
      ),
    );
  }

  void _simpanResep() {
    if (_formKey.currentState!.validate() && _gambarValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pop(context, {
          'nama': _namaController.text,
          'ringkasan': _ringkasanController.text,
          'gambar': _gambarController.text,
          'caraMasak': _caraMasakController.text,
          'favorit': false,
          'isLocal': false,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Resep Makanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Resep',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama resep wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ringkasanController,
                decoration: const InputDecoration(
                  labelText: 'Ringkasan Resep',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ringkasan wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gambarController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty && !_gambarValid) {
                    return 'Gambar tidak dapat ditampilkan, periksa link!';
                  }
                  return null;
                },
                onChanged: (url) {
                  _cekGambarValid(url);
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Preview Gambar',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AspectRatio(
                aspectRatio: 16 / 9, 
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _gambarController.text.isNotEmpty
                      ? Image.network(
                          _gambarController.text,
                          fit: BoxFit.contain, 
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.broken_image, size: 48)),
                        )
                      : const Center(child: Icon(Icons.add_a_photo, size: 48)),
                ),
              ),
              if (!_gambarValid)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Gambar tidak dapat ditampilkan, periksa link!',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caraMasakController,
                decoration: const InputDecoration(
                  labelText: 'Detail Cara Masak',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Detail cara masak wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _simpanResep,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}