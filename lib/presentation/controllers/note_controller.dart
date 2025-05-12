import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/notes_model.dart';

class NotesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Form-related properties
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // State properties
  RxList<NoteModel> notes = <NoteModel>[].obs;
  RxBool isLoading = false.obs;

  // Fetch all notes for current user
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
      Get.snackbar('Error', 'Failed to fetch notes');
    }
  }

  // Add a new note
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

      // Clear text controllers
      titleController.clear();
      descriptionController.clear();

      // Stop loading and navigate back
      isLoading.value = false;
      context.pop();
      Get.snackbar(
        'Success',
        'Note added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // Stop loading
      isLoading.value = false;
      print('Error adding note: $e');
      Get.snackbar('Error', 'Failed to add note');
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
    } catch (e) {
      print('Error deleting note: $e');
      Get.snackbar('Error', 'Failed to delete note');
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