import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordstudy_app/colors/colorRes.dart';

enum ContentType { lesson, test }

class ContentListScreen extends StatefulWidget {
  final ContentType type;
  final Widget createScreen;

  const ContentListScreen({
    super.key,
    required this.type,
    required this.createScreen,
  });

  @override
  State<ContentListScreen> createState() => _ContentListScreenState();
}

class _ContentListScreenState extends State<ContentListScreen> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;
  String get title =>
      widget.type == ContentType.lesson ? "Your Lessons" : "Your Tests";

  String get collection =>
      widget.type == ContentType.lesson ? "lessons" : "tests";

  String get buttonText =>
      widget.type == ContentType.lesson ? "Create Lesson" : "Create Test";

  IconData get icon =>
      widget.type == ContentType.lesson ? Icons.menu_book : Icons.quiz;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection("teachers")
          .doc(uid)
          .collection(collection)
          .orderBy("created_at", descending: true)
          .get();

      final fetched = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "title": data["title"] ?? "Untitled",
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        items = fetched;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);
    }
  }

  /// 🗑 DELETE (same logic)
  Future<void> deleteItem(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("teachers")
        .doc(uid)
        .collection(collection)
        .doc(id)
        .delete();

    fetchItems();
  }

  /// ⚠️ DELETE DIALOG (same UI)
  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.type == ContentType.lesson
                      ? "Delete Lesson?"
                      : "Delete Test?",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "This action cannot be undone",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: _btn("Cancel", Colors.white.withOpacity(0.2)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);

                          final messenger =
                              ScaffoldMessenger.of(this.context);

                          await deleteItem(id);

                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.type == ContentType.lesson
                                    ? "Lesson deleted"
                                    : "Test deleted",
                              ),
                            ),
                          );
                        },
                        child: _btn("Delete", Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _btn(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/SimpleWordsBGImage.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.45),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                if (isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (items.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.type == ContentType.lesson
                            ? "You haven't created any lessons yet"
                            : "You haven't created any tests yet",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: fetchItems,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _card(item["title"], item["id"]);
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      /// 🔥 FAB (same logic, dynamic screen)
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorRes.primaryAppColor,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => widget.createScreen),
          );
          fetchItems();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          buttonText,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  /// 🔥 CARD (same UI)
  Widget _card(String title, String id) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.yellow, size: 28),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18)),
                const SizedBox(height: 4),
                Text("Code: $id",
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied")),
              );
            },
            child: const Icon(Icons.copy, color: Colors.white70),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: () => showDeleteDialog(id),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
    );
  }
}