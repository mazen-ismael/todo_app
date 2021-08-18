import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazen_flutter_001/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:mazen_flutter_001/modules/done_tasks/done_tasks_screen.dart';
import 'package:mazen_flutter_001/modules/new_tasks/new_tasks_screen.dart';
import 'package:mazen_flutter_001/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List titles = [
    'New tasks',
    'Done tasks',
    'Archived tasks',
  ];

  Database? database;
  List newTasks = [];
  List doneTasks = [];
  List archivedTasks = [];


  var isBottomSheetShown = false;

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  void changeIndex(index) {
    currentIndex = index;
    emit(ChangeIndexState());
  }

  var floatButtonIcon = Icon(Icons.edit);

  void floatIcon() {
    if (isBottomSheetShown) {
      floatButtonIcon = Icon(Icons.add);
    } else {
      floatButtonIcon = Icon(Icons.edit);
    }
    emit(ChangeBottomSheetIconState());
  }

  void closeBottomSheet(context) {
    Navigator.pop(context);
  }

  void openDataBase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
          print('database created');
          database
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT )')
              .then((value) {
            print('table created');
          }).catchError((onError) {
            print('error when creating the table ${onError.toString()}');
          });
        }, onOpen: (database) {
          print('database opened');
          getDataFromDatabase(database);
        });
  }

  Future insertToDatabase({
    @required String? title,
    @required String? time,
    @required String? date,
  }) async {
    return await database!.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks(title , time , date , status) VALUES("$title" , "$time" , "$date" , "new")')
          .then((value) {
        print('$value inserted successfully');
        getDataFromDatabase(database);
      }).catchError((onError) {
        print('error when inserting ${onError.toString()}');
      });
      return getName();
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database!.rawQuery('SELECT * FROM "tasks"').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(GetDataState());
    });
  }

  Future<String> getName() async {
    return 'mazen';
  }

  void updateDatabase({
    @required status,
    @required int? id,
  }) async {
    await database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(StatusUpdateState());
    });
  }

  void deleteDatabase({
    @required int? id,
  }) async {
    await database!.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id])
    .then((value) {
    getDataFromDatabase(database);
    emit(DeleteState());
    });
  }


}
