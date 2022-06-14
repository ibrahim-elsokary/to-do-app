// ignore_for_file: unused_local_variable

import 'package:first_app/layout/tasky/cubit/cubit.dart';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



Widget defaultButton({
  required context,
  double wid = double.infinity,
  double r = 5.0,
  required String text,
  bool isUpper = true,
  Color bgClolor = Colors.blue,
  required void Function()? onPressed,
}) =>
    Container(
      width: wid,
      decoration: BoxDecoration(
        color: bgClolor,
        borderRadius: BorderRadius.circular(
          r,
        ),
      ),
      child: FlatButton(
        onPressed: onPressed,
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );

Widget defaultFormField(
  context, {
  required controller,
  hint = '',
  required type,
  Function? onType,
  isPassword = false,
  Icon? prefixcIcon,
  IconButton? suffixIcon,
  Function(dynamic value)? onFaildSubmitted,
  VoidCallback? onTap,
  Function(String)? onChanged,
  String? Function(String? val)? validator,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: TextFormField(
        validator: validator,
        onFieldSubmitted: onFaildSubmitted,
        onTap: onTap,
        onChanged: onChanged,
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixcIcon,
          hintText: hint,
          errorStyle: Theme.of(context).textTheme.bodyText1,
          helperStyle: Theme.of(context).textTheme.bodyText1,
          floatingLabelStyle: Theme.of(context).textTheme.bodyText1,
          labelStyle: Theme.of(context).textTheme.bodyText1,
          counterStyle: Theme.of(context).textTheme.bodyText1,
          border: InputBorder.none,
        ),
      ),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinsh(context, widget) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ), (value) {
      return false;
    });

Widget buildSeparator() => Container(
      height: 1.0,
      width: double.infinity,
      color: Colors.grey[300],
    );

Widget task(context, {required Map map}) {
  return Dismissible(
    key: Key(map['id'].toString()),
    onDismissed: (direction) {
      TaskyCubit.get(context).delDatabase(
        TaskyCubit.get(context).database,
        id: map['id'],
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              child: Text('${map['time']}'),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${map['title']}',
                    maxLines: 2,
                  ),
                  Text('${map['date']}', maxLines: 2),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  TaskyCubit.get(context).updateDatabase(
                      TaskyCubit.get(context).database,
                      id: map['id'],
                      status: 'done');
                },
                icon: Icon(Icons.check_box)),
            IconButton(
                onPressed: () {
                  TaskyCubit.get(context).updateDatabase(
                      TaskyCubit.get(context).database,
                      id: map['id'],
                      status: 'archive');
                },
                icon: Icon(Icons.archive_outlined))
          ],
        ),
      ),
    ),
  );
}



void showToast({required String msg, required state}) {
  Fluttertoast.showToast(
      msg: msg,
      backgroundColor: toastColor(state),
      fontSize: 14,
      textColor: Colors.white,
      timeInSecForIosWeb: 5,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG);
}

// ignore: constant_identifier_names
enum ToastState { ERROR, SUCCESS, WARNING }
Color toastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WARNING:
      color = Colors.orange;
      break;
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
  }

  return color;
}
