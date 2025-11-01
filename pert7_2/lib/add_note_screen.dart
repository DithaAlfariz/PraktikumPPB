import 'package:flutter/material.dart';
import 'db/database_helper.dart';
import 'models/note.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note; // jika non-null => edit
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      if (widget.note == null) {
        // create
        final newNote = Note(
          title: titleController.text,
          content: contentController.text,
          createdAt: DateTime.now(),
        );
        await dbHelper.insertNote(newNote);
        Navigator.pop(context, true); // kembali dan beri tahu ada perubahan
      } else {
        // update
        final updated = Note(
          id: widget.note!.id,
          title: titleController.text,
          content: contentController.text,
          createdAt: widget.note!.createdAt,
        );
        await dbHelper.updateNote(updated);
        Navigator.pop(context, true); // beri tahu ada perubahan
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Catatan" : "Tambah Catatan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) =>
                    value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Isi catatan'),
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? 'Isi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveNote, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}