import 'package:flutter/material.dart';
import 'package:flutter_firebase_ddd_aug/injection.dart';
import 'package:flutter_firebase_ddd_aug/presentation/core/app_widget.dart';
import 'package:injectable/injectable.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(AppWidget());
}
