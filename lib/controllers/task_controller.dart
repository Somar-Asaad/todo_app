import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  final obxTaskList = <Task>[
    Task(
      id: 4,
      title: 'Title 4',
      note: 'Note 4 something',
      startTime: DateFormat('hh:mm a')
          .format(
            DateTime.now().add(
              const Duration(minutes: 1),
            ),
          )
          .toString(),
      endTime: '2:43',
      isCompleted: 1,
      color: 1,
    ),

  ]as Obx;

  addTask(Task task)async{
    await DBHelper.insert(task);
  }
  getTask(Task task) {
    await DBHelper.query(task)
  }
}
