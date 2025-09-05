import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:quantday/core/inject/inject.dart';
import 'package:quantday/layers/presentation/pages/tabs_wrapper.dart';

void main() {
  mainContext.config = mainContext.config.clone(
    writePolicy: ReactiveWritePolicy.always,
  );

  Inject.init();

  runApp(
    MaterialApp(
      title: 'QuantDay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
      ),
      home: TabsWrapper(),
    ),
  );
}
