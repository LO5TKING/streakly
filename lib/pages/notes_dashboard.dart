import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../controllers/notes_controller.dart';
import '../model/note.dart';
import '../widgets/unlock_note_dialog.dart';
import 'note_detail_page.dart';

class NotesDashboard extends StatelessWidget {
  const NotesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final notesCtrl = Get.put(NotesController());
    return Scaffold(
      appBar: AppBar(title: const Text('SecureNotes')),
      body: Obx(() {
        if (notesCtrl.notes.isEmpty) {
          return const Center(child: Text('No Notes Yet'));
        }
        return ListView.builder(
          itemCount: notesCtrl.notes.length,
          itemBuilder: (context, index) {
            final note = notesCtrl.notes[index];
            return ListTile(
              title: Text(note.title),
              leading: note.locked ? const Icon(Icons.lock) : null,
              onTap: () async {
                if (note.locked) {
                  final unlocked = await Get.dialog<bool>(
                    UnlockNoteDialog(note: note),
                    barrierDismissible: false,
                  );
                  if (unlocked != true) return;
                }
                Get.to(() => NoteDetailPage(note: note));
              },
              trailing: IconButton(
                icon: Icon(
                  note.locked ? Icons.lock_open : Icons.lock,
                  color: note.locked ? Colors.red : Colors.grey,
                ),
                onPressed: () => notesCtrl.toggleLock(index),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => NoteDetailPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
