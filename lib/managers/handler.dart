import 'package:project_1/controllers/rachascontroller.dart';
import 'package:project_1/controllers/taskcontroller.dart';
import 'package:project_1/models/tarea.dart';
import 'package:project_1/ui/components/logo.dart';
import 'package:project_1/ui/components/navigationbtn.dart';
import 'package:project_1/ui/pages/calendar/calendar_widget.dart';
import 'package:project_1/ui/pages/home/home.dart';
import 'package:project_1/ui/pages/calendar/calendar.dart';
import 'package:project_1/ui/pages/profile/profile.dart';
import 'package:project_1/ui/pages/profile/profilemenu_widget.dart';
import 'package:project_1/ui/pages/tareas/components/task_bool.dart';
import 'package:project_1/ui/pages/tareas/components/task_qkt.dart';
import 'package:project_1/ui/pages/tareas/tareas_add.dart';
import 'package:flutter/material.dart';
import 'package:project_1/ui/pages/tareas/tareas_list.dart';

/// This handler will be use to get reusable components and functions.
/// This will help to keep the code clean and easy to read.

Logo getLogo(double height, double width) {
  return Logo(height, width);
}

Text prederminedText(String text, double fontSize) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize, color: const Color.fromARGB(255, 244, 244, 244)),
  );
}

NavigationButton getNavigationButton(String text, String route) {
  return NavigationButton(text, route);
}

CalendarWidget getCalendarWidget(
    final ValueNotifier<DateTime?> selectedDayNotifier) {
  return CalendarWidget(selectedDayNotifier: selectedDayNotifier);
}

TaskQkt getTaskQkt(Tarea task) {
  return TaskQkt(
    tarea: task,
  );
}

TaskBool getTaskBool(Tarea task) {
  return TaskBool(
    tarea: task,
  );
}

ProfileMenuWidget getProfileMenuWidget(
    {required String title,
    required IconData icon,
    MaterialColor? textColor,
    bool? endIcon,
    required VoidCallback onPress}) {
  return ProfileMenuWidget(
    title: title,
    icon: icon,
    onPress: onPress,
  );
}

/// getPages
HomePage getHomePage() {
  return const HomePage();
}

Calendar getCalendarPage() {
  return const Calendar();
}

ProfilePage getProfilePage() {
  return const ProfilePage();
}

TareasPage getTareasListPage(List<Tarea> tareas) {
  return TareasPage(tareas: tareas);
}

TareasAddPage getTareasAddPage() {
  return const TareasAddPage();
}

bool isRachaActive(int? racha) {
  if (getRachasController().superRachaNumber > 0) {
    return true;
  }
  if (racha != null) {
    racha > 0 ? true : false;
  }
  return false;
}

SizedBox getRachaImage(int racha, double width, double height,
    {bool completada = false}) {
  String imageurl;
  if (isRachaActive(racha) || completada) {
    imageurl = "assets/images/racha_activa.png";
  } else {
    imageurl = "assets/images/racha_desactiva.png";
  }
  return SizedBox(
    width: width,
    height: height,
    child: ClipRRect(
      child: Image(image: AssetImage(imageurl)),
    ),
  );
}

//get Controllers
TaskController getTaskController() {
  return TaskController.instance;
}

RachasController getRachasController() {
  return RachasController.instance;
}
