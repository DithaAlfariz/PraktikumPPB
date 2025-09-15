import 'package:flutter/material.dart';
import 'models/mahasiswa.dart';

class InputMahasiswaPage extends StatefulWidget {
  const InputMahasiswaPage({super.key});

  @override
  State<InputMahasiswaPage> createState() => _InputMahasiswaPageState();
}

class _InputMahasiswaPageState extends State<InputMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kontakController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _umurController.dispose();
    _alamatController.dispose();
    _kontakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Mahasiswa")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Nama wajib diisi" : null,
              ),
              TextFormField(
                controller: _umurController,
                decoration: const InputDecoration(labelText: "Umur"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? "Umur wajib diisi" : null,
              ),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: "Alamat"),
                validator: (value) => value == null || value.isEmpty
                    ? "Alamat wajib diisi"
                    : null,
              ),
              TextFormField(
                controller: _kontakController,
                decoration: const InputDecoration(labelText: "Kontak"),
                validator: (value) => value == null || value.isEmpty
                    ? "Alamat wajib diisi"
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final mahasiswa = Mahasiswa(
                      nama: _namaController.text,
                      umur: int.tryParse(_umurController.text) ?? 0,
                      alamat: _alamatController.text,
                      kontak: _kontakController.text,
                    );
                    Navigator.pop(context, mahasiswa);
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
