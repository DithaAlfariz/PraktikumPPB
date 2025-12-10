import 'package:flutter/material.dart';
import 'models/post.dart';
import 'home_page.dart';
import 'messages_list_page.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  String selectedType = "open_help";

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController categoryController = TextEditingController(); // <-- Tambahan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF7A0C29),
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MessagesListPage()),
              (route) => false,
            );
          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile page coming soon')),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7A0C29), Color(0xFF9b163a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Posting",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),

          // ================= FORM =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type
                  const Text("Tipe", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      Radio(
                        value: "open_help",
                        activeColor: const Color(0xFF7A0C29),
                        groupValue: selectedType,
                        onChanged: (value) => setState(() => selectedType = value!),
                      ),
                      const Text("Bisa ngajarin"),
                      const SizedBox(width: 14),
                      Radio(
                        value: "need_help",
                        activeColor: const Color(0xFF7A0C29),
                        groupValue: selectedType,
                        onChanged: (value) => setState(() => selectedType = value!),
                      ),
                      const Text("Butuh bantuan"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Title
                  buildLabel("Topik"),
                  buildInput("Masukkan topik...", controller: titleController),

                  const SizedBox(height: 20),

                  // Description
                  buildLabel("Deskripsi"),
                  buildInput("Jelaskan detail...", maxLines: 5, controller: descController),

                  const SizedBox(height: 20),

                  // ================= CATEGORY INPUT (BARU) =================
                  buildLabel("Kategori"),
                  buildInput(
                    "Contoh: Pemrograman, Flutter, Basis Data...",
                    controller: categoryController,
                  ),

                  const SizedBox(height: 30),

                  // Publish Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final newPost = PostModel(
                          type: selectedType == "open_help" ? "Bisa Ngajarin" : "Butuh Bantuan",
                          typeColor: selectedType == "open_help" ? Colors.green : Colors.red,
                          title: titleController.text,
                          desc: descController.text,
                          category: categoryController.text, // <-- Menyimpan kategori
                          name: "User",
                        );

                        Navigator.pop(context, newPost);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A0C29),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Publikasikan", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildLabel(String text) =>
      Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600));

  Widget buildInput(String hint,
      {int maxLines = 1, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
