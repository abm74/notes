import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class NoteDetails extends StatelessWidget {
  const NoteDetails({required this.note, super.key});
  final Note note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(234, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: const Center(
          // widthFactor: 3,
          child: Text(
            'Notes',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 24),
          ),
        ),
      ),
      body: Center(
        heightFactor: 1,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color.fromARGB(255, 255, 189, 9),
              ),
              child: Row(
                children: [
                  const Text(
                    'Title ',
                    style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 94, 6, 77),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Color.fromARGB(203, 255, 255, 255),
                      ),
                      child: Text(
                        note.title,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color.fromARGB(255, 255, 189, 9),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Content',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 94, 6, 77),
                              fontWeight: FontWeight.bold),
                          // textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      constraints: const BoxConstraints(minHeight: 150),
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Color.fromARGB(203, 255, 255, 255),
                      ),
                      child: Text(note.body, style: TextStyle(fontSize: 18))),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
