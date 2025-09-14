import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notes_controller.dart';
import 'package:voice_note_kit/voice_note_kit.dart';

import '../controllers/voice_note_controller.dart';
import '../model/note.dart'; // example voice package import

class NoteDetailPage extends StatefulWidget {
  final Note? note;
  const NoteDetailPage({super.key, this.note});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool isLocked = false;
  String? voicePath;

  final NotesController notesCtrl = Get.find<NotesController>();

  /// Voice note controller (setup according to the package you pick)
  final VoiceNoteController voiceController = VoiceNoteController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    isLocked = widget.note?.locked ?? false;
    voicePath = widget.note?.voicePath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    voiceController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) {
      Get.snackbar('Error', 'Please enter a title or content.');
      return;
    }
    final newNote = Note(
      title: title,
      content: content,
      voicePath: voicePath,
      locked: isLocked,
    );

    if (widget.note == null) {
      notesCtrl.addNote(newNote);
    } else {
      final index = notesCtrl.notes.indexOf(widget.note!);
      notesCtrl.updateNote(index, newNote);
    }
    Get.back();
  }

  void _startRecording() async {
    await voiceController.startRecording();
  }

  void _stopRecording() async {
    final path = await voiceController.stopRecording();
    setState(() {
      voicePath = path;
    });
  }

  void _playVoiceNote() {
    if (voicePath != null) {
      voiceController.play(voicePath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: Icon(isLocked ? Icons.lock : Icons.lock_open),
            onPressed: () {
              setState(() {
                isLocked = !isLocked;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.mic),
                  label: const Text('Record'),
                  onPressed: _startRecording,
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  onPressed: _stopRecording,
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                  onPressed: _playVoiceNote,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
