import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/models/note.dart';

enum NoteData { title, body, date }

class NotesRepository {
  NotesRepository() {
    notesRef = FirebaseFirestore.instance.collection('notes');
  }
// notesRef = FirebaseFirestore.instance.collection('notes');
  late final CollectionReference<Map<String, dynamic>> notesRef;

  // Stream<List<Note>> loadNotes() {
  Future<List<Note>> loadNotes() async {
    // return notesRef.snapshots().map((snapshot) => snapshot.docs.map((document) {
    //       final id = document.reference.id;
    //       final data = document.data();
    //       return Note(
    //           title: data['title'],
    //           body: data['body'],
    //           date: data['date'],
    //           id: id);
    //     }).toList());
    final snapshot = await notesRef.get();
    return snapshot.docs.map((document) {
      final id = document.reference.id;
      final data = document.data();
      return Note(
          title: data['title'],
          body: data['body'],
          date: data['date'].toDate(),
          id: id);
    }).toList();
  }

  Future<String?> addNote(Note note) async {
    try {
      final docRef = await notesRef.add({
        NoteData.title.name: note.title,
        NoteData.body.name: note.body,
        NoteData.date.name: note.date,
      });
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteNote(Note note) async {
    try {
      final snapshot = await notesRef.doc(note.id).delete();
      return true;
    } catch (e) {
      return false;
    }

    // .delete();
    // notesRef.doc().delete();
  }

  Future<bool> updateNote(Note note) async {
    try {
      notesRef.doc(note.id).update({
        NoteData.title.name: note.title,
        NoteData.body.name: note.body,
        NoteData.date.name: note.date,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
