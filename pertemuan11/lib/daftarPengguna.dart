import 'package:flutter/material.dart';
import 'pengguna.dart';

class DaftarPengguna extends StatefulWidget {
  const DaftarPengguna({super.key});

  @override
  State<DaftarPengguna> createState() => _DaftarPenggunaState();
}

class _DaftarPenggunaState extends State<DaftarPengguna> {
  final Pengguna pengguna = Pengguna();
  late Future<List<dynamic>> posts;

  @override
  void initState() {
    super.initState();
    posts = pengguna.fetchPosts();
  }

  void _refreshData() {
    setState(() {
      posts = pengguna.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengguna'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final post = data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post['name'] ?? 'No Name'),
                      const SizedBox(height: 8),
                      Text(post['email'] ?? 'No Email'),
                      const SizedBox(height: 8),
                      Text(post['address']['city'] ?? 'No Address'),
                    ],
                  ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}