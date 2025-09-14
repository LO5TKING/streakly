import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model/note.dart';

class NotesController extends GetxController {
  late Box<Note> notesBox;
  var notes = <Note>[].obs;

  @override
  void onInit() {
    super.onInit();
    notesBox = Hive.box<Note>('notesBox');
    notes.value = notesBox.values.toList();
  }

  void addNote(Note note) {
    notesBox.add(note);
    notes.value = notesBox.values.toList();
  }

  void updateNote(int index, Note note) {
    notesBox.putAt(index, note);
    notes.value = notesBox.values.toList();
  }

  void deleteNoteAt(int index) {
    notesBox.deleteAt(index);
    notes.value = notesBox.values.toList();
  }

  void toggleLock(int index) {
    final note = notes[index];
    note.locked = !note.locked;
    note.save();
    notes.value = notesBox.values.toList();
  }
}
