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
      child: StreamBuilder<ThemeMode>(
          stream: bloc.themeModeStream,
          builder: (context, snapshot) {
            return MaterialApp(
              title: 'Todo App',
              debugShowCheckedModeBanner: false,
              themeMode: snapshot.data,
              theme: ThemeData(
                brightness: Brightness.light,
                fontFamily: 'ProductSans',
                primaryColor: Color(0xFF433D82),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                fontFamily: 'ProductSans',
                primaryColor: Color(0xffa29bfe),
              ),
              home: HomePage(),
            );
          }),
    );
  }
}
