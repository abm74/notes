import 'package:equatable/equatable.dart';

class Note extends Equatable {
  Note(
      {required this.title, required this.body, required this.date, String? id})
      : id = id ?? DateTime.now().toString();
  final String id;
  final DateTime date;
  final String title;
  final String body;
  @override
  List<Object?> get props => [id];
  Note copyWith({String? title, String? body, DateTime? date, String? id}) =>
      Note(
          title: title ?? this.title,
          body: body ?? this.body,
          date: date ?? this.date,
          id: id ?? this.id);
}
