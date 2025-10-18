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

  // helper: format TimeOfDay ke 12-hour dengan AM/PM
  String formatTimeOfDay(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String get tglLahirLabel => tglLahir == null
    ? 'Pilih Tanggal Lahir'
    : '${tglLahir!.day}/${tglLahir!.month}/${tglLahir!.year}';
  String get jamLabel => jamBimbingan == null ? 'Pilih Jam Bimbingan' : formatTimeOfDay(jamBimbingan!);

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

    // Navigasi ke halaman hasil dan kirim data sebagai parameter
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          nama: cNama.text.trim(),
          npm: cNPM.text.trim(),
          email: cEmail.text.trim(),
          noHp: cNoHP.text.trim(),
          alamat: cAlamat.text.trim(),
          jenisKelamin: jenisKelamin!,
          tanggalLahir: tglLahirLabel,
          jamBimbingan: jamLabel,
        ),
      ),
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

// Halaman hasil untuk menampilkan data yang dikirim lewat navigasi
class ResultPage extends StatelessWidget {
  final String nama;
  final String npm;
  final String email;
  final String noHp;
  final String alamat;
  final String jenisKelamin;
  final String tanggalLahir;
  final String jamBimbingan;

  const ResultPage({
    super.key,
    required this.nama,
    required this.npm,
    required this.email,
    required this.noHp,
    required this.alamat,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.jamBimbingan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Pengisian')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama: $nama'),
                const SizedBox(height: 8),
                Text('NPM: $npm'),
                const SizedBox(height: 8),
                Text('Email: $email'),
                const SizedBox(height: 8),
                Text('Nomor HP: $noHp'),
                const SizedBox(height: 8),
                Text('Alamat: $alamat'),
                const SizedBox(height: 8),
                Text('Jenis Kelamin: $jenisKelamin'),
                const SizedBox(height: 8),
                Text('Tanggal Lahir: $tanggalLahir'),
                const SizedBox(height: 8),
                Text('Jam Bimbingan: $jamBimbingan'),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}