import 'package:flutter/material.dart';
import 'models/post.dart';
import 'add_post_page.dart';
import 'detail_postingan_page.dart';
import 'messages_list_page.dart';
import 'profile_page.dart';
import 'database/post_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  String selectedCategory = "Semua";

  // List posting dinamis
  List<PostModel> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final loadedPosts = await PostStorage.loadPosts();
    setState(() {
      posts = loadedPosts;
    });
  }

  Future<void> _addPost(PostModel newPost) async {
    setState(() {
      posts.add(newPost);
    });
    await PostStorage.savePosts(posts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7A0C29),
        onPressed: () async {
          final newPost = await Navigator.push<PostModel>(
            context,
            MaterialPageRoute(builder: (context) => const AddPostPage()),
          );

          if (newPost != null) {
            await _addPost(newPost);
          }
        },
        child: const Icon(Icons.add, color: Colors.white,),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF7A0C29),
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MessagesListPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),

      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24,
                      ),
                      child: const Icon(Icons.school, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "SkillMate",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // SEARCH BAR
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Cari skill, topik, kategori...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // CATEGORY LIST
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                categoryChip("Semua"),
                categoryChip("Bisa Ngajarin"),
                categoryChip("Butuh Bantuan"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // POST LIST
          Expanded(
            child: posts.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada postingan.\nKlik tombol + untuk membuat postingan.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: getFilteredPosts()
                        .map((post) => postCard(post: post))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  // CATEGORY CHIP
  Widget categoryChip(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selectedCategory == label
              ? const Color(0xFF7A0C29)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selectedCategory == label ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // FILTER POST (Search + Filter Kategori)
  List<PostModel> getFilteredPosts() {
    return posts.where((post) {
      final query = searchQuery.toLowerCase();

      final matchSearch = query.isEmpty ||
          post.title.toLowerCase().contains(query) ||
          post.desc.toLowerCase().contains(query) ||
          post.category.toLowerCase().contains(query);

      final matchCategory =
          selectedCategory == "Semua" || post.type == selectedCategory;

      return matchSearch && matchCategory;
    }).toList();
  }

  // POST CARD ITEM
  Widget postCard({required PostModel post}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPostinganPage(post: post),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TYPE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: post.typeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                post.type,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              post.desc,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 10),

            // CATEGORY TAG
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                post.category,
                style: const TextStyle(fontSize: 12),
              ),
            ),

            const SizedBox(height: 14),

            // PROFILE
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF7A0C29),
                  child: Text(
                    post.name[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  post.name,
                  style:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),

                const Spacer(),

                Text(
                  "Message",
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF7A0C29),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
