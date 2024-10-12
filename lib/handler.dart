import 'package:project_1/ui/components/logo.dart';
import 'package:project_1/ui/components/navigationbtn.dart';
import 'package:project_1/ui/components/calendar_widget.dart';
import 'package:project_1/ui/pages/home.dart';
import 'package:project_1/ui/pages/calendar.dart';
import 'package:project_1/ui/pages/profile/profile.dart';
import 'package:project_1/ui/components/profilemenu_widget.dart';
import 'package:flutter/material.dart';

/// This handler will be use to get reusable components and functions.

Logo getLogo(double height, double width) {
  return Logo(height, width);
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

bool isRachaActive() {
  // This function will be used to check if the user has an active racha, will change when implemented
  return false;
}

String getRachaImagePath() {
  return isRachaActive()
      ? "assets/images/racha_activa.png"
      : "assets/images/racha_desactiva.png";
}
