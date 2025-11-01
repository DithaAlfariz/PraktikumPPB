import 'package:flutter/material.dart';
import 'db/database_helper.dart';
import 'models/note.dart';
import 'add_note_screen.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;
  final dbHelper = DatabaseHelper();

  NoteDetailScreen({super.key, required this.note});

  String _formatDate(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2,'0')}-${dt.day.toString().padLeft(2,'0')} ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Catatan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text("Dibuat: ${_formatDate(note.createdAt)}",
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(note.content, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "edit",
              onPressed: () async {
                final changed = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddNoteScreen(note: note),
                  ),
                );
                if (changed == true) {
                  Navigator.pop(context, true);
                }
              },
              child: const Icon(Icons.edit),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: "delete",
              backgroundColor: Colors.red,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Hapus catatan?"),
                    content: const Text("Anda yakin ingin menghapus catatan ini?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false), 
                        child: const Text("Batal")
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text("Hapus")
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await dbHelper.deleteNote(note.id!);
                  Navigator.pop(context, true);
                }
              },
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}