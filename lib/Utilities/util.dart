// TODO: Konverter alt med EnlistmentStates til bool?

// DO NOT CHANGE THE NAMES IN THIS ENUM
// They will have to be manually changed in every saved StudentWeekData file
import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app/Widgets/ColoredCupertinoButton.dart';

enum EnlistmentStates { none, enlisted, rejected }

EnlistmentStates boolToEnlistmentStates(bool b) {
  return b ? EnlistmentStates.enlisted : EnlistmentStates.rejected;
}

bool EnlistmentStatesToBool(EnlistmentStates state) {
  return state == EnlistmentStates.enlisted ? true : false;
}

Widget makeSquareButton(VoidCallback? fn, icon, iconColor, fillColor) {
  return SizedBox(
    width: 60,
    height: 60,
    child: ColoredButton.filled(
        onPressed: fn,
        customDisabledColor: CupertinoColors.systemGrey3,
        fillColor: fillColor,
        child: Icon(
          icon,
          color: iconColor,
        )),
  );
}

String dayNumberInWeekToDayString(int dayNumber) {
  switch (dayNumber) {
    case 1:
      return "Mandag";
    case 2:
      return "Tirsdag";
    case 3:
      return "Onsdag";
    case 4:
      return "Torsdag";
    case 5:
      return "Fredag";
    case 6:
      return "Lørdag";
    case 7:
      return "Søndag";
  }
  return "";
}

String monthNumberToMonthString(int monthNumber) {
  switch (monthNumber) {
    case 1:
      return "januar";
    case 2:
      return "februar";
    case 3:
      return "marts";
    case 4:
      return "april";
    case 5:
      return "maj";
    case 6:
      return "juni";
    case 7:
      return "juli";
    case 8:
      return "august";
    case 9:
      return "september";
    case 10:
      return "oktober";
    case 11:
      return "november";
    case 12:
      return "december";
  }

  return "";
}