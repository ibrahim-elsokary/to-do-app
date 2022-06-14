// ignore_for_file: override_on_non_overriding_member

import 'package:first_app/layout/tasky/componants.dart';
import 'package:first_app/layout/tasky/cubit/cubit.dart';
import 'package:first_app/layout/tasky/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class S2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskyCubit, TaskyStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return taskList(context, map: TaskyCubit.get(context).doneTasks);
      },
    );
  }
}
