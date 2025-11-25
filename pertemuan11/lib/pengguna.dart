import 'dart:convert';
import 'package:http/http.dart' as http;

class Pengguna {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/users';

  Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data pengguna');
    }
  }
}