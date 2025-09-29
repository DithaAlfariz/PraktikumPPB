import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Halaman Formulir',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const FormMahasiswaPage(),
  );
}

class FormMahasiswaPage extends StatefulWidget {
  const FormMahasiswaPage({super.key});

  @override
  State<FormMahasiswaPage> createState() => _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final cNama = TextEditingController();
  final cNPM = TextEditingController();
  final cEmail = TextEditingController();
  final cAlamat = TextEditingController();
  final cNoHP = TextEditingController();

  DateTime? tglLahir;
  TimeOfDay? jamBimbingan;
  String? jenisKelamin;

  String get tglLahirLabel => tglLahir == null
    ? 'Pilih Tanggal Lahir'
    : '${tglLahir!.day}/${tglLahir!.month}/${tglLahir!.year}';
  String get jamLabel => jamBimbingan == null ? 'Pilih Jam Bimbingan' : '${jamBimbingan!.hour}:${jamBimbingan!.minute}';

  @override
  void dispose(){
    cNama.dispose();
    cNPM.dispose();
    cEmail.dispose();
    cAlamat.dispose();
    cNoHP.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async{
    final res = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (res != null) setState(() => tglLahir = res);
  }

  Future<void> _pickTime() async{
    final res = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (res != null) setState(() => jamBimbingan = res);
  }

  void _simpan(){
    if (!_formKey.currentState!.validate() || tglLahir == null || jamBimbingan == null || jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data Belum Lengkap')));
      return;
    }
    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: const Text('Ringkasan Data'),
        content: Text(
          'Nama: ${cNama.text}\n'
          'NPM: ${cNPM.text}\n'
          'Email: ${cEmail.text}\n'
          'No HP: ${cNoHP.text}\n'
          'Alamat: ${cAlamat.text}\n'
          'Jenis Kelamin: $jenisKelamin\n'
          'Tanggal Lahir: $tglLahirLabel\n'
          'Jam Bimbingan: $jamLabel\n'
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Formulir Mahasiswa')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: cNama,
              decoration: const InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) =>
                value == null || value.isEmpty ? 'Nama harus diisi' : null,
            ),
            TextFormField(
              controller: cNPM,
              decoration: const InputDecoration(
                labelText: 'NPM',
                prefixIcon: Icon(Icons.badge),
              ),
              keyboardType: TextInputType.number,
              validator: (value) =>
                value == null || value.isEmpty ? 'NPM harus diisi' : null,
            ),
            TextFormField(
              controller: cEmail,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Email harus diisi';
                }
                final ok = RegExp(r'^[^@]+@unsika\.ac\.id$').hasMatch(v.trim());
                return ok ? null : 'Email harus domain @unsika.ac.id';
              },
            ),
            TextFormField(
              controller: cNoHP,
              decoration: const InputDecoration(
                labelText: 'Nomor HP',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor HP harus diisi';
                }
                final onlyDigits = RegExp(r'^\d{10,}$');
                return onlyDigits.hasMatch(value) ? null : 'Nomor HP minimal 10 digit dan hanya angka';
              },
            ),
            TextFormField(
              controller: cAlamat,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                prefixIcon: Icon(Icons.home),
              ),
              maxLines: 3,
              validator: (value) =>
                value == null || value.isEmpty ? 'Alamat harus diisi' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Jenis Kelamin',
                prefixIcon: Icon(Icons.wc),
              ),
              value: jenisKelamin,
              items: const [
                DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
              ],
              onChanged: (val) => setState(() => jenisKelamin = val),
              validator: (value) =>
                value == null ? 'Jenis Kelamin harus dipilih' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(tglLahirLabel),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickTime,
              icon: const Icon(Icons.access_time),
              label: Text(jamLabel),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    ),
  );
}