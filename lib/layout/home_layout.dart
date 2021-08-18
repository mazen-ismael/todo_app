import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mazen_flutter_001/shared/components/components.dart';
import 'package:mazen_flutter_001/shared/cubit/cubit.dart';
import 'package:mazen_flutter_001/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titleValue = TextEditingController();
  var timeValue = TextEditingController();
  var dateValue = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..openDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if(state==InsertToDatabaseState()){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertToDatabase(
                            title: titleValue.text,
                            time: timeValue.text,
                            date: dateValue.text)
                        .then((value) {
                          cubit.isBottomSheetShown=false;
                      cubit.floatIcon();
                      Navigator.pop(context);
                    });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => SingleChildScrollView(
                          child: Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                          textEditingController: titleValue,
                                          textInputType: TextInputType.text,
                                          labelText: 'Task title',
                                          prefixIcon:
                                              Icon(Icons.title_outlined),
                                          textOfValidation:
                                              'title must not be empty'),
                                      SizedBox(height: 20),
                                      defaultFormField(
                                        textEditingController: timeValue,
                                        textInputType: TextInputType.datetime,
                                        labelText: 'Task Time',
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
                                        textOfValidation:
                                            'time must not be empty',
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timeValue.text =
                                                value!.format(context);
                                            print(value
                                                .format(context)
                                                .toString());
                                          });
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      defaultFormField(
                                        textEditingController: dateValue,
                                        textInputType: TextInputType.datetime,
                                        labelText: 'Task Date',
                                        prefixIcon:
                                            Icon(Icons.calendar_today_outlined),
                                        textOfValidation:
                                            'date must not be empty',
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2021-07-27'),
                                          ).then((value) {
                                            dateValue.text = DateFormat.yMMMd()
                                                .format(value!);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                        cubit.isBottomSheetShown=false;
                    cubit.floatIcon();
                  });
                  cubit.isBottomSheetShown=true;
                  cubit.floatIcon();
                }
              },
              child: cubit.floatButtonIcon,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
