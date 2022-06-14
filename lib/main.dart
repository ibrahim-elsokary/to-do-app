// ignore_for_file: unused_import, prefer_const_constructors, implementation_imports

import 'dart:io';

import 'package:bloc/bloc.dart';


import 'package:first_app/network/locale/cashHelper.dart';
import 'package:first_app/network/remote/dioHelper.dart';
import 'package:first_app/shared/blocObserver.dart';
import 'package:first_app/shared/components/components.dart';

import 'package:first_app/styles/thems.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/services/system_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:intl/intl.dart';

import 'layout/tasky/cubit/cubit.dart';
import 'layout/tasky/cubit/states.dart';
import 'layout/tasky/home.dart';
import 'network/locale/httpHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();




  Widget? startWidget;

  

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  runApp(MyApp(
  
    startScreen: Home(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({this.isDark, this.startScreen});

  final bool? isDark;
  final Widget? startScreen;

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(0, 0, 0, 0));
    return MultiBlocProvider(
      providers: [

        BlocProvider(
          create: (context) => TaskyCubit()..creatDatabase(),
        ),

      ],
      child: BlocConsumer<TaskyCubit, TaskyStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(

            debugShowCheckedModeBanner: false,
            home: startScreen,
          );
        },
      ),
    );
  }
}
