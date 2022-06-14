// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:first_app/shared/components/components.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskyCubit, TaskyStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TaskyCubit.get(context);

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text('Tasky'),
          ),
          body: cubit.screens?[cubit.navIndex],
          bottomNavigationBar: bottomNav(context),
          floatingActionButton: FloatingActionButton(
            child: Icon(cubit.fab),
            onPressed: () {
              // cubit.changFab();
              if (cubit.isShow) {
                if (formKey.currentState!.validate()) {
                  cubit.fab = Icons.edit;
                  cubit.isShow = false;
                  cubit.changFab();
                  cubit
                      .insrtIntoDatabase(
                    title: textController.text,
                    date: dateController.text,
                    time: timeController.text,
                  )
                      .whenComplete(() {
                    cubit.getDataFromDatabase(cubit.database);
                  });

                  Navigator.pop(context);
                }
              } else {
                cubit.fab = Icons.add;
                cubit.isShow = true;
                scaffoldKey.currentState
                    ?.showBottomSheet((context) => bottomSheet(context));
              }
            },
          ),
        );
      },
    );
  }
}

var scaffoldKey = GlobalKey<ScaffoldState>();
late var formKey = GlobalKey<FormState>();
var textController = TextEditingController();
var dateController = TextEditingController();
var timeController = TextEditingController();

Widget bottomNav(context) {
  return BottomNavigationBar(
      elevation: 15,
      onTap: (value) {
        TaskyCubit.get(context).changeNav();
        TaskyCubit.get(context).navIndex = value;
      },
      currentIndex: TaskyCubit.get(context).navIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_rounded), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.archive_rounded), label: ''),
      ]);
}

Widget bottomSheet(BuildContext context) {
  return Form(
    key: formKey,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[250],
                  borderRadius: BorderRadius.circular(20)),
              child: defaultFormField(
                context,
                hint: 'enter task title',
                prefixcIcon: Icon(Icons.task),
                controller: textController,
                type: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'is empty';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[250],
                  borderRadius: BorderRadius.circular(20)),
              child: defaultFormField(
                context,
                hint: 'enter date',
                prefixcIcon: Icon(Icons.calendar_today_outlined),
                controller: dateController,
                type: TextInputType.datetime,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2023),
                  ).then((value) {
                    dateController.text =
                        DateFormat.yMMMd().format(value!).toString();
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'is empty';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[250],
                  borderRadius: BorderRadius.circular(20)),
              child: defaultFormField(
                context,
                hint: 'enter time',
                prefixcIcon: Icon(Icons.watch_rounded),
                controller: timeController,
                type: TextInputType.datetime,
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    timeController.text = value!.format(context).toString();
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'is empty';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
