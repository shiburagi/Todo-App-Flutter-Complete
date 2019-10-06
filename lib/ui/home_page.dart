import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc.dart';
import 'package:flutter_todo_app/ui/home_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bloc bloc = Provider.of<Bloc>(context);
    return Scaffold(
      body: HomeView(),
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
        StreamBuilder<Brightness>(
            stream: bloc.brightnessStream,
            builder: (context, snapshot) {
              bool isLightMode = snapshot.data == Brightness.light;
              return InkWell(
                onTap: bloc.updateBrightness,
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
