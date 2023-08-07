import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:untitled/modules/done_tasks/done_tasks_screen.dart';
import 'package:untitled/modules/new_Tasks/new_tasks_screen.dart';
import 'package:untitled/shared/cubit/state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  Database? database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  bool isBottomSheetShown = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController timerController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks Screen',
    'Done Tasks Screen',
    'Archived Tasks Screen',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void changeBottomSheetShown({required bool isShow}) {
    isBottomSheetShown = isShow;
    emit(AppChangeBottomSheetState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db', version: 1,

      // id integer
      // title String
      // data String
      // time String
      // status String

      onCreate: (database, version) async {
        debugPrint('Database created');
        await database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          debugPrint('table is create');
        }).catchError((error) {
          debugPrint('error When Create Table is ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        //   debugPrint('Database opened');
        //   debugPrint('$database');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    }).catchError((getError) {
      debugPrint("there is error in get database which is $getError");
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        debugPrint('$value insert has been successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      });
      return null;
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void getDataFromDatabase(Database? database) async {
    emit(AppGetDatabaseLoadingState());
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    database!.rawQuery('SELECT * FROM tasks').then((value) {
      for (var element in value) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'archive') {
          archiveTasks.add(element);
        }
      }

      emit(AppGetDatabaseState());

      //   // debugPrint('${tasks?[1]}');
      //   // debugPrint('${tasks?[1]['title']}');
      //   // debugPrint('${tasks?[1]['time']}');
    }).catchError((error) {
      debugPrint('there is error in get database which is $error');
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) async {
    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      debugPrint('this is the Update database which is $value');
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    }).catchError((updateError) {
      debugPrint('the is error in update database which is $updateError');
    });
  }

  void deleteDatabase({
    required int id,
  }) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
    .then((value) {
      debugPrint('this is the Delete database which is $value');
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    }).catchError((deleteError) {
      debugPrint('the is error in Delete database which is $deleteError');
    });
  }





}
