import 'package:flutter/cupertino.dart';
import 'package:hansenberg_app/Models/StudentNotifier.dart';
import 'package:hansenberg_app/Utilities/Clients/EnlistmentClient.dart';
import 'package:hansenberg_app/Utilities/Clients/MenuClient.dart';
import 'package:hansenberg_app/Utilities/Clients/StudentClient.dart';
import 'package:hansenberg_app/Utilities/TokenStorage.dart';
import 'package:provider/provider.dart';
import 'package:week_of_year/date_week_extensions.dart';

import 'StudentWeekPage.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({
    Key? key,
    required this.menuClient,
    required this.enlistmentClient,
    required this.studentClient,
    required this.tokenStorage
  }) : super(key: key);

  final MenuClient menuClient;
  final EnlistmentClient enlistmentClient;
  final StudentClient studentClient;
  final TokenStorage tokenStorage;

  String initialRoute() {
    DateTime now = DateTime.now();
    return "${now.weekOfYear}";
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final week = int.parse(settings.name!);

    final now = DateTime.now();

    final difference = 7 * (week - now.weekOfYear);

    final next = now.add(Duration(days: difference));

    final mondayOfWeek = next.subtract(Duration(days: next.weekday - 1));

    WidgetBuilder builder;

    builder = (BuildContext context) => StudentWeekPage(
      mondayOfWeek: mondayOfWeek,
      menuClient: menuClient,
      enlistmentClient: enlistmentClient,
      tokenStorage: tokenStorage,
    );

    return PageRouteBuilder(pageBuilder: (BuildContext context, _, __) => builder(context));
  }

  void showActionSheet(BuildContext context, {required List<CupertinoActionSheetAction> actions} ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Indstillinger', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        // message: const Text('Message'),
        actions: actions,
      ),
    );
  }

  Future _deleteUser() async {
    studentClient.deleteStudent(await tokenStorage.readToken());
    tokenStorage.deleteToken();
  }

  @override
  Widget build(BuildContext context) {

    String studentName = context.select<StudentNotifier, String>(
          (notifier) => notifier.student!.studentName,
    );

    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.secondarySystemBackground,
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            onPressed: () => showActionSheet(
                context,
                actions: <CupertinoActionSheetAction> [
                  CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () async {
                      await _deleteUser();
                      Future.delayed(Duration.zero, () {
                        Navigator.pushReplacementNamed(context, '/');
                      });
                    },
                    child: const Text('Slet bruger!'),
                  )
                ]
            ),
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.gear, size: 30,),
          ),
          middle: studentName.isNotEmpty ? Text("Hej $studentName!") : null,
          trailing: CupertinoButton(
            // TODO: Implement chat
            onPressed: () => print("Chat"),
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.chat_bubble_text, size: 30),
          ),
        ),
        child: Navigator(
          initialRoute: initialRoute(),
          onGenerateRoute: (RouteSettings settings) => onGenerateRoute(settings),
        )
    );
  }
}