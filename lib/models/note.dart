import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Note extends Equatable {
  Note(
      {required this.title,
      required this.body,
      required this.timestamp,
      String? id})
      : id = id ?? Timestamp.now().toString();
  final String id;
  final Timestamp timestamp;
  final String title;
  final String body;
  @override
  List<Object?> get props => [id];
  Note copyWith(
          {String? title, String? body, Timestamp? timestamp, String? id}) =>
      Note(
          title: title ?? this.title,
          body: body ?? this.body,
          timestamp: timestamp ?? this.timestamp,
          id: id ?? this.id);
}
