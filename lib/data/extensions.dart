import 'person.dart';

extension ResponsibilityExtension on Responsibility {
  String toNameString() {
    return name.replaceAll('_', ' ');
  }
}
