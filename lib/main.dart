import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/bloc/bloc.dart';
import 'package:flutter_todo_app/ui/home_page.dart';
import 'package:provider/provider.dart';

void main() => SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).then((_) {
      runApp(new MyApp());
    });

Bloc bloc = Bloc();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<Bloc>(
      builder: (context) => bloc,
      dispose: (context, Bloc item) => item.dispose(),
      child: StreamBuilder<Brightness>(
          stream: bloc.brightnessStream ?? Brightness.light,
          builder: (context, snapshot) {
            return MaterialApp(
              title: 'Todo App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: snapshot.data,
                fontFamily: 'ProductSans',
                primarySwatch: Colors.blue,
              ),
              home: Material(child: HomePage()),
            );
          }),
    );
  }
}
