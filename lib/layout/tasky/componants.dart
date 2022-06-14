// ignore_for_file: non_constant_identifier_names

import 'package:first_app/shared/components/components.dart';

import 'package:flutter/material.dart';

Widget taskList(context, {required List<Map> map}) {
  return ListView.separated(
      itemBuilder: (context, index) {
        return task(context, map: map[index]);
      },
      separatorBuilder: (context, index) {
        return Container();
      },
      itemCount: map.length);
}
