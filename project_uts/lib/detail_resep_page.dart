import 'package:flutter/material.dart';

class DetailResepPage extends StatelessWidget {
  final Map<String, dynamic> resep;

  const DetailResepPage({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(resep['nama'] ?? 'Detail Resep'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  resep['gambar'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 80),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              resep['nama'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              resep['ringkasan'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Cara Masak:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              resep['caraMasak'] ?? 'Belum ada cara masak.',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}