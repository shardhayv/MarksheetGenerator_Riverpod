import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marksheet_generator/view/add_marksheet_view.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Riverpod state management',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const AddMarkSheetView(),
        },
      ),
    ),
  );
}
