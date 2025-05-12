import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:online_notes/utils/custom_toast.dart';
import '../../data/models/notes_model.dart';

class NotesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  RxList<NoteModel> notes = <NoteModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchNotes() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      final querySnapshot = await _firestore
          .collection('notesUsers')
          .doc(user.uid)
          .collection('notes')
          .orderBy('createdAt', descending: true)
          .get();

      notes.value = querySnapshot.docs
          .map((doc) => NoteModel.fromMap(doc.data(), doc.id))
          .toList();
      isLoading.value = false;
    } catch (e) {
      print('Error fetching notes: $e');
      CustomToast.show(message: 'Failed to fetch notes', backgroundColor: Colors.red);
    }
  }

  Future<void> addNote(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    try {
      // Start loading
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) {
        isLoading.value = false;
        return;
      }

      final newNote = NoteModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
      );

      final docRef = await _firestore
          .collection('notesUsers')
          .doc(user.uid)
          .collection('notes')
          .add(newNote.toMap());

      newNote.id = docRef.id;
      notes.insert(0, newNote);

      titleController.clear();
      descriptionController.clear();

      isLoading.value = false;
      context.pop();
      CustomToast.show(message: 'Note added successfully');
    } catch (e) {
      // Stop loading
      isLoading.value = false;
      print('Error adding note: $e');
      CustomToast.show(message: 'Failed to add note', backgroundColor: Colors.red);
    }
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('notesUsers')
          .doc(user.uid)
          .collection('notes')
          .doc(noteId)
          .delete();

      notes.removeWhere((note) => note.id == noteId);
      CustomToast.show(message: 'Note removed successfully');
    } catch (e) {
      print('Error deleting note: $e');
      CustomToast.show(message: 'Failed to delete note', backgroundColor: Colors.red);
    }
  }

  @override
  void onInit() {
    fetchNotes();
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}