import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/ui/size_config.dart';

import '../../models/task.dart';
import '../theme.dart';

class TaskTile extends StatelessWidget {
  TaskTile(
    this.task, {
    Key? key,
  }) : super(key: key);
  Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: SizeConfig.orientation == Orientation.landscape
          ? const EdgeInsets.all(4)
          : const EdgeInsets.all(6),
      child: Container(
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: colorPicker(task.color!),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${task.startTime} - ${task.endTime}',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      task.note!,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              width: 0.5,
              color: Colors.grey[300],
            ),
            const SizedBox(
              width: 5,
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                Task().isCompleted == 0 ? 'TODO' : 'Completed',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    color: Colors.grey[300],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color colorPicker(int color) {
    switch (color) {
      case 0:
        return primaryClr;
      case 1:
        return orangeClr;
      case 2:
        return pinkClr;
      default:
        return primaryClr;
    }
  }
}
