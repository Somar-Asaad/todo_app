import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/theme.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/theme_services.dart';
import '../size_config.dart';
import '../widgets/button.dart';
import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime startDate = DateTime.now();
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        margin: const EdgeInsets.only(
          right: 10,
          left: 20,
          top: 10,
        ),
        child: Column(
          children: [
            _buildAddTaskBar(),
            _buildDatePicker(),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTaskBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat().add_yMMMd().format(DateTime.now()).toString(),
              style: subHeadingStyle,
            ),
            Text(
              'Today',
              style: headingStyle,
            ),
          ],
        ),
        MyButton(
          label: '+ Add Task',
          onTap: () async {
            await Get.to(() => const AddTaskPage());
            _taskController.getTask();
          },
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        color: Get.isDarkMode ? Colors.white : Colors.black,
        icon: Get.isDarkMode
            ? const Icon(Icons.wb_sunny_outlined)
            : const Icon(Icons.nightlight_round_outlined),
        onPressed: () {
          ThemeServices().switchTheme();
          // notifyHelper.displayNotification(title: 'Theme Changed', body: 'fdf');
          // notifyHelper.scheduledNotification();
        },
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
  }

  Widget _buildDatePicker() {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
      ),
      child: DatePicker(
        DateTime.now(),
        width: 80.0,
        height: 100.0,
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        initialSelectedDate: DateTime.now(),
        onDateChange: (newVal) {
          setState(
            () {
              startDate = newVal;
            },
          );
        },
      ),
    );
  }

  Widget _showTasks() {
    if (false /*TaskController().taskList.isEmpty*/) {
      return Expanded(child: noTaskMessage());
    } else {
      return Expanded(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            Task task = TaskController().taskList[index];
            var hour = task.startTime.toString().split(':')[0];
            var minute = task.startTime.toString().split(':')[1];
            debugPrint('My time is$hour');
            debugPrint('My minute is $minute');
            var date = DateFormat.jm().parse(task.startTime!);
            var myTime = DateFormat('HH:mm').format(date);

            notifyHelper.scheduledNotification(
              int.parse(myTime.toString().split(':')[0]),
              int.parse(myTime.toString().split(':')[1]),
              task,
            );
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 1300),
              child: SlideAnimation(
                horizontalOffset: 300,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, task);
                    },
                    child: TaskTile(task),
                  ),
                ),
              ),
            );
          },
          itemCount: TaskController().taskList.length,
        ),
      );
    }
  }

  Stack noTaskMessage() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(
                        height: 6,
                      )
                    : const SizedBox(
                        height: 240,
                      ),
                SvgPicture.asset(
                  'images/task.svg',
                  semanticsLabel: 'Task',
                  color: primaryClr.withOpacity(0.4),
                  height: 90,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'You do not have any tasks yet! Add new tasks to make your days productive.',
                  style: subTitleStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: darkHeaderClr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      clr: primaryClr,
                      label: 'Task Completed',
                      onTap: () {
                        Get.back();
                      },
                      isClose: false,
                    ),
              _buildBottomSheet(
                clr: primaryClr,
                label: 'delete Task',
                onTap: () {
                  Get.back();
                },
                isClose: false,
              ),
              const Divider(
                color: Colors.grey,
              ),
              _buildBottomSheet(
                clr: primaryClr,
                label: 'Cancel',
                onTap: () {
                  Get.back();
                },
                isClose: false,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet({
    required Color clr,
    required String label,
    required Function() onTap,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.screenWidth * 0.9,
        height: 65,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr,
              width: 2),
          color: isClose ? Colors.transparent : clr,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            label,
            style: isClose == false
                ? titleStyle.copyWith(color: Colors.white)
                : titleStyle,
          ),
        ),
      ),
    );
  }
}
