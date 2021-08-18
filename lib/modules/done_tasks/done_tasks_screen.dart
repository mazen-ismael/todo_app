import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazen_flutter_001/shared/components/components.dart';
import 'package:mazen_flutter_001/shared/cubit/cubit.dart';
import 'package:mazen_flutter_001/shared/cubit/states.dart';
class DoneTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) =>AppCubit.get(context).doneTasks.length == 0
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 125,
              color: Colors.grey,
            ),
            Text(
              'No Done Tasks Yet',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,

              ),
            ),
          ],
        ),
      )
          : ListView.separated(
        itemBuilder: (c, i) => buildTaskItem(
          id: AppCubit.get(context).doneTasks[i]['id'],
          title: AppCubit.get(context).doneTasks[i]['title'],
          time: AppCubit.get(context).doneTasks[i]['time'],
          date: AppCubit.get(context).doneTasks[i]['date'],
          context: context,
        ),
        separatorBuilder: (c, i) => Padding(
          padding: const EdgeInsetsDirectional.only(start: 22),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey,
          ),
        ),
        itemCount: AppCubit.get(context).doneTasks.length,
      ),
    );
  }}
