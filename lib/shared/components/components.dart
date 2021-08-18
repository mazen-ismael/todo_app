import 'package:flutter/material.dart';
import 'package:mazen_flutter_001/shared/cubit/cubit.dart';

Widget defaultButton({
  Color color = Colors.blue,
  double width = double.infinity,
  @required var onPressed,
  @required var text,
}) =>
    Container(
      color: color,
      width: width,
      height: 40,
      child: MaterialButton(
        onPressed: onPressed,
        height: 40,
        child: Text(
          '$text',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultFormField({
  @required TextEditingController? textEditingController,
  @required TextInputType? textInputType,
  @required String? labelText,
  @required Icon? prefixIcon,
  @required String? textOfValidation,
  bool securedText = false,
  IconButton? suffixButton,
  var onTap,
}) =>
    TextFormField(
      validator: (String? value) {
        if (value!.isEmpty) {
          return textOfValidation;
        } else {
          return null;
        }
      },
      controller: textEditingController,
      keyboardType: textInputType,
      obscureText: securedText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: prefixIcon,
        suffixIcon: suffixButton,
      ),
      onTap: onTap,
    );

Widget buildTaskItem({
  @required title,
  @required time,
  @required date,
  @required id,
  @required context,
}) =>
    Dismissible(
      key: Key('$id'),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                time,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateDatabase(status: "done", id: id);
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateDatabase(status: "archived", id: id);
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.black54,
                )),
          ],
        ),
      ),
      onDismissed: (direction){
        AppCubit.get(context).deleteDatabase(id: id);
      },
    );
