import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';

import '../../controllers/task_controller.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: bodyBuilder(),
    );
  }

  SingleChildScrollView bodyBuilder() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            'Add Task',
            style: headingStyle,
          ),
          InputField(
            title: 'Title',
            hint: 'Enter title here.',
            controller: _titleController,
          ),
          InputField(
            title: 'Note',
            hint: 'Enter note here.',
            controller: _noteController,
          ),
          InputField(
            title: 'Date',
            hint: DateFormat.yMd().format(_selectedDate).toString(),
            widget: IconButton(
              onPressed: () {
                dateTimeChooser();
              },
              icon: const Icon(
                Icons.calendar_today_outlined,
                color: Colors.grey,
                size: 24,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InputField(
                  title: 'Start Time',
                  hint: _startTime,
                  widget: IconButton(
                    onPressed: () {
                      timeTypeChooser(isStart: true);
                    },
                    icon: const Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InputField(
                  title: 'End Time',
                  hint: _endTime,
                  widget: IconButton(
                    onPressed: () {
                      timeTypeChooser(isStart: false);
                    },
                    icon: const Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          InputField(
            title: 'Remind',
            hint: '$_selectedRemind minutes early',
            widget: DropdownButton(
              dropdownColor: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10.0),
              icon: const Icon(Icons.keyboard_arrow_down),
              value: _selectedRemind.toString(),
              elevation: 4,
              underline: Container(
                height: 0,
              ),
              items: remindList
                  .map<DropdownMenuItem<String>>(
                    (int value) => DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(
                        '$value',
                      ),
                    ),
                  )
                  .toList(),
              style: subTitleStyle,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRemind = int.parse(newValue!);
                });
              },
            ),
          ),
          InputField(
            title: 'Repeat',
            hint: _selectedRepeat,
            widget: DropdownButton(
              dropdownColor: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10.0),
              icon: const Icon(Icons.keyboard_arrow_down),
              value: _selectedRepeat,
              elevation: 4,
              underline: Container(
                height: 0,
              ),
              items: repeatList
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    ),
                  )
                  .toList(),
              style: subTitleStyle,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRepeat = newValue!;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Color',
                    style: titleStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _colorPalete(),
                ],
              ),
              MyButton(
                label: 'Create Task',
                onTap: () {
                  dateBalance();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() => AppBar(
        leading: IconButton(
          color: Colors.grey[400],
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: const [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
          SizedBox(width: 10),
        ],
      );

  Widget _colorPalete() {
    return Row(
      children: List<Widget>.generate(
        3,
        (index) => GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: index == 0
                  ? bluishClr
                  : index == 1
                      ? pinkClr
                      : orangeClr,
              child: index == _selectedColor
                  ? const Icon(
                      Icons.done,
                      size: 20,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  dateBalance() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      addTaskToTheDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'Required!',
        'All fields are required',
        colorText: pinkClr,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: pinkClr,
        ),
        backgroundColor: Colors.white,
      );
    } else {
      print('######## some erroe occured#######');
    }
  }

  addTaskToTheDb() async {
    int value = await TaskController().addTask(
      Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
  }

  void timeTypeChooser({required bool isStart}) async {
    TimeOfDay? value = await showTimePicker(
      context: context,
      initialTime: isStart
          ? TimeOfDay.fromDateTime(
              DateTime.now(),
            )
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(
                  minutes: 15,
                ),
              ),
            ),
    );
    String formattedTime = value!.format(context);
    if (value == null) {
      print('nothing important just happened');
    } else if (value != null) {
      setState(() {
        isStart == true ? _startTime = formattedTime : _endTime = formattedTime;
      });


    } else {
      print('something wrong just happened');
    }
  }

  void dateTimeChooser() async {
    DateTime? value = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (value == null) {
      print('cancelled simply');
    } else if (value != null) {
     setState(() {
       _selectedDate = value;
     });
    } else {
      print('some error occured');
    }
  }
}
