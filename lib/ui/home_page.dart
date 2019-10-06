import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/bloc/bloc.dart';
import 'package:flutter_todo_app/ui/home_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bloc bloc = Provider.of<Bloc>(context);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: bloc.isDarkTheme(context)
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: HomeView(),
      ),
      endDrawer: _buildDrawer(bloc),
    );
  }

  Drawer _buildDrawer(Bloc bloc) {
    return Drawer(
      child: Container(
        child: _buildDrawerContent(bloc),
      ),
    );
  }

  ListView _buildDrawerContent(Bloc bloc) {
    return ListView(
      children: <Widget>[
        StreamBuilder<ThemeMode>(
            stream: bloc.themeModeStream,
            builder: (context, snapshot) {
              bool isLightMode = !bloc.isDarkTheme(context);
              return InkWell(
                onTap: () => bloc.updateBrightness(context),
                child: ListTile(
                  trailing: Icon(
                      isLightMode ? Icons.brightness_2 : Icons.brightness_high),
                  title: Text(isLightMode ? "Dark" : "Light"),
                ),
              );
            }),
      ],
    );
  }
}
