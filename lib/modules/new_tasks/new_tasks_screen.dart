import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazen_flutter_001/shared/components/components.dart';
import 'package:mazen_flutter_001/shared/cubit/cubit.dart';
import 'package:mazen_flutter_001/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => AppCubit.get(context).newTasks.length == 0
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu,
                    size: 125,
                    color: Colors.grey,
                  ),
                  Text(
                    'No Tasks Yet, please add tasks',
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
                id: AppCubit.get(context).newTasks[i]['id'],
                title: AppCubit.get(context).newTasks[i]['title'],
                time: AppCubit.get(context).newTasks[i]['time'],
                date: AppCubit.get(context).newTasks[i]['date'],
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
              itemCount: AppCubit.get(context).newTasks.length,
            ),
    );
  }
}
