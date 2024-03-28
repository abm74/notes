import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

enum NoteData { title, body, timestamp }

class Response {
  Response(this.success, {this.message});
  final bool success;
  final String? message;
}

class NotesRepository {
  NotesRepository();
  final notesRef = FirebaseFirestore.instance.collection('notes');

  Future<bool> hasActiveConnection() async {
    final result = await Connectivity().checkConnectivity();
    if (result[0] == ConnectivityResult.none) {
      return false;
    } else {
      try {
        final addresses = await InternetAddress.lookup('example.com');
        if (addresses.isNotEmpty && addresses[0].rawAddress.isNotEmpty) {
          return true;
        }
      } catch (e) {
        debugPrint('Error: $e');
        return false;
      }
    }

    return false;
  }

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

  Future<Response> addNote(Note note) async {
    if (!await hasActiveConnection()) {
      return Response(false, message: 'No internet connection');
    }
    try {
      await notesRef.add({
        NoteData.title.name: note.title,
        NoteData.body.name: note.body,
        NoteData.timestamp.name: note.timestamp,
      });
      return Response(true);
    } catch (e) {
      return Response(false);
    }
  }

  Future<Response> deleteNote(Note note) async {
    if (!await hasActiveConnection()) {
      return Response(false, message: 'No internet connection');
    }
    try {
      final doc = await notesRef.doc(note.id).get();
      if (doc.exists) {
        print('Doc exists');
        doc.reference.delete();
      } else {
        print('Document doesn\'t exist');
        return Response(false);
      }

      return Response(true);
    } catch (e) {
      print('Delete error: $e');
      return Response(false);
    }
  }

  Future<Response> updateNote(Note note) async {
    if (!await hasActiveConnection()) {
      return Response(false, message: 'No internet connection');
    }
    try {
      final doc = await notesRef.doc(note.id).get();
      if (doc.exists) {
        print('doc exists');
        doc.reference.set({
          NoteData.title.name: note.title,
          NoteData.body.name: note.body,
          NoteData.timestamp.name: note.timestamp,
        });
        return Response(true);
      } else {
        print('doc doesn\'t exist');
        return Response(false);
      }
    } catch (e) {
      debugPrint('Update error: $e');
      return Response(false);
    }
  }
}
