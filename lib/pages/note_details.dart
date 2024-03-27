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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color.fromARGB(255, 198, 26, 255),
              ),
              child: Row(
                children: [
                  const Text(
                    'Title ',
                    style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 255, 239, 252),
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
                        color: Color.fromARGB(240, 255, 255, 255),
                      ),
                      child: Text(
                        note.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
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
                color: Color.fromARGB(255, 198, 26, 255),
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
                              fontSize: 22,
                              color: Color.fromARGB(255, 248, 235, 246),
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
                      constraints:
                          const BoxConstraints(minHeight: 150, maxHeight: 400),
                      alignment: Alignment.topLeft,
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: const Color.fromARGB(232, 255, 255, 255),
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        trackVisibility: true,
                        thickness: 7,
                        interactive: true,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              note.body,
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
