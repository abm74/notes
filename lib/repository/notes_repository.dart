import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

enum NoteData { title, body, timestamp }

class NotesRepository {
  NotesRepository();
  final notesRef = FirebaseFirestore.instance.collection('notes');

  Stream<List<Note>> loadNotes() {
    return notesRef
        .orderBy(NoteData.timestamp.name, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) {
              final id = document.id;
              final data = document.data();
              return Note(
                  title: data[NoteData.title.name],
                  body: data[NoteData.body.name],
                  timestamp: data[NoteData.timestamp.name],
                  id: id);
            }).toList());
  }

  Future<String?> addNote(Note note) async {
    try {
      final docRef = await notesRef.add({
        NoteData.title.name: note.title,
        NoteData.body.name: note.body,
        NoteData.timestamp.name: note.timestamp,
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
  }

  Future<bool> updateNote(Note note) async {
    try {
      notesRef.doc(note.id).update({
        NoteData.title.name: note.title,
        NoteData.body.name: note.body,
        NoteData.timestamp.name: note.timestamp,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
