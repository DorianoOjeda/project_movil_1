import './ui/components/logo.dart';
import './ui/components/navigationbtn.dart';
import 'ui/pages/home.dart';

/// This handler will be use to get reusable components and functions.

Logo getLogo(double height, double width) {
  return Logo(height, width);
}

NavigationButton getNavigationButton(String text, String route) {
  return NavigationButton(text, route);
}

/// getPages
HomePage getHomePage() {
  return const HomePage();
}
