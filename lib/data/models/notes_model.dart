import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String? id;
  String title;
  String description;
  DateTime createdAt;

  NoteModel({
    this.id,
    required this.title,
    required this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map, String docId) {
    return NoteModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}