import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_themes.dart';
import 'dao.dart';
import 'parameters_page.dart';

class MyHomePage extends StatefulWidget {

  final ThemeData theme;

  MyHomePage({Key? key, required this.theme}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String imageWine = 'assets/images/wine_bottle.png';

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero,() {
      showDialog(
        context: context, builder: (context) {
          setCustomTheme(context);
          return Container();
        }
      );
      new Future.delayed(Duration(microseconds: 1),() {
        Navigator.pop(context);
      });
    });
  }

  void setCustomTheme(BuildContext buildContext) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('theme')) {
      if(prefs.getString('theme') == 'MyThemeKeys.CUSTOM'){
        int? bgColor = prefs.getInt('backgroundColor');

        Color? accentColor;
        if(prefs.containsKey('accentColor')){
          int ?accentColorCode = prefs.getInt('accentColor');
          accentColor = Color(accentColorCode!);
        }
        else {
          accentColor = Colors.teal;
        }

        Color? primaryColor = Colors.black;
        Brightness? brightness = Brightness.dark;
        if(prefs.containsKey('appBarTheme')) {

          if(prefs.getString('appBarTheme') == 'MyThemeKeys.LIGHT') {
            primaryColor = Colors.lightBlue;
            brightness = Brightness.light;
          }
        }

        CustomTheme.instanceOf(buildContext).newCustomTheme(
          ThemeData(
            scaffoldBackgroundColor: Color(bgColor!),
            accentColor: accentColor,
            primaryColor: primaryColor,
            brightness: brightness,
            backgroundColor: primaryColor,
          )
        );
      }
    }
  }

  void _getWine() async {
    final response = await DAO().getAllWines();
    print(response.toString());
  }

  void _setWine() {
    // Auto generated data
    DAO().addWine();
  }

  void _navigateParameters() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ParametersPage(theme: widget.theme)),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(tr('wine_management')),
      bottom: TabBar(
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.home),
          ),
          Tab(
            icon: Icon(Icons.liquor),
          ),
          Tab(
            icon: Icon(Icons.photo_camera),
          ),
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    return new TabBarView(
      children: <Widget>[
        Center(
          child: mainPage(context),
        ),
        Center(
          child: listPage(context),
        ),
        Center(
          child: new Text("Photo"),
        ),
      ],
    );
  }

  Widget floatingActionButtons(BuildContext context) {
    return Stack(
      children: <Widget> [
        Align(
          alignment: Alignment(1.0, -0.5),
          child: FloatingActionButton(
            heroTag: "btn1",
            onPressed: _navigateParameters,
            tooltip: tr('parameters'),
            child: Icon(Icons.settings),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: "btn2",
            onPressed: _getWine,
            tooltip: tr('new_bottle'),
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget mainPage(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(tr('wine_management')),
        Image(image: AssetImage(imageWine)),
      ],
    );
  }

  Widget listPage(BuildContext context) {

    return FutureBuilder(
      future: DAO().getAllWines(),
      builder: (context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return SizedBox.shrink();
        }
        else {
          if (snapshot.error != null) {
            return Center(
                child: Text('An error occured')
            );
          }
          else {
            print(snapshot.data);
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                      onTap: () {
                        // Actions
                      },
                      title: Text(snapshot.data[index]['desc']),
                      subtitle: Text(snapshot.data[index]['desc']),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        foregroundImage: AssetImage(imageWine),
                      ),
                    )
                );
              }
            );
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: widget.theme,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: appBar(context),
            body: body(context),
            floatingActionButton: floatingActionButtons(context),
        ),
      ),
    );
  }
}