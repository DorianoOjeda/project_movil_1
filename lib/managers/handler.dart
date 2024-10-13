import 'package:project_1/ui/components/logo.dart';
import 'package:project_1/ui/components/navigationbtn.dart';
import 'package:project_1/ui/components/calendar_widget.dart';
import 'package:project_1/ui/pages/home.dart';
import 'package:project_1/ui/pages/calendar.dart';
import 'package:project_1/ui/pages/profile/profile.dart';
import 'package:project_1/ui/components/profilemenu_widget.dart';
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
    style: TextStyle(fontSize: fontSize, color: Colors.black),
  );
}

NavigationButton getNavigationButton(String text, String route) {
  return NavigationButton(text, route);
}

CalendarWidget getCalendarWidget() {
  return const CalendarWidget();
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

Profile getProfilePage() {
  return const Profile();
}

TareasPage getTareasListPage(List<Map<String, dynamic>> tareas) {
  return TareasPage(tareas: tareas);
}

TareasAddPage getTareasAddPage() {
  return const TareasAddPage();
}

bool isRachaActive() {
  // This function will be used to check if the user has an active racha, will change when implemented
  return false;
}

SizedBox getRachaImage() {
  double width;
  double height;
  String imageurl;
  if (isRachaActive()) {
    width = 120;
    height = 120;
    imageurl = "assets/images/racha_activa.png";
  } else {
    width = 100;
    height = 100;
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

String getSuperRachaNumber() {
  // This function will be used to get the number of the super racha, will change when implemented
  return "0";
}
