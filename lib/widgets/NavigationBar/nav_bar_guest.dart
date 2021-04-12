import 'package:cos/views/auth/login.dart';
import 'package:cos/views/auth/register.dart';
import 'package:cos/views/home/GuestPages/homeview.dart';
import 'package:cos/views/home/GuestPages/hotbread.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class CollapsingNavigationDrawerGuest extends StatefulWidget {
  @override
  CollapsingNavigationDrawerGuestState createState() {
    return new CollapsingNavigationDrawerGuestState();
  }
}

class CollapsingNavigationDrawerGuestState extends State<CollapsingNavigationDrawerGuest>
    with SingleTickerProviderStateMixin {
  List<ScreenHiddenDrawer> itens = [];


  @override
  void initState() {
    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Southern Cross",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 28.0 ),
          colorLineSelected: Colors.teal,
        ),
        HomePage()));

    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Hot Bread Kitchen",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 28.0 ),
          colorLineSelected: Colors.deepOrangeAccent,
        ),
        HotBreadPage()));

    itens.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Dining Resturant 1",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 28.0 ),
          colorLineSelected: Colors.orange,
        ),
        HotBreadPage()
    )
    );

    itens.add(new ScreenHiddenDrawer(

        new ItemHiddenMenu(
          name: "Dining Resturant 2",
          baseStyle: TextStyle( color: Colors.white.withOpacity(0.8), fontSize: 28.0 ),
          colorLineSelected: Colors.pink,
        ),
        RegistrationPage()
    )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.blueGrey,
      backgroundColorAppBar: Colors.blueGrey,
      screens: itens,
      //    typeOpen: TypeOpen.FROM_RIGHT,
      //    disableAppBarDefault: false,
      //    enableScaleAnimin: true,
      //    enableCornerAnimin: true,
          slidePercent: 50.0,
      //    verticalScalePercent: 80.0,
      //    contentCornerRadius: 10.0,
      //    iconMenuAppBar: Icon(Icons.menu),
      //    backgroundContent: DecorationImage((image: ExactAssetImage('assets/bg_news.jpg'),fit: BoxFit.cover),
      //    whithAutoTittleName: true,
      //    styleAutoTittleName: TextStyle(color: Colors.red),
          actionsAppBar: <Widget>[
            Padding(padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                },
                child: const Text("Login",style:TextStyle(color:Colors.white),),
              ),
            ),
            Padding(padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                },
                child: const Text("Register",style:TextStyle(color:Colors.white),),
              ),
            ),

            Container(
              padding:const EdgeInsets.all(10) ,
              child: Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart,size: 30,),
                    onPressed: (){
                      _showMyDialog();
                    },
                  ),

                ],
              ),
            )

          ],
      //    backgroundColorContent: Colors.blue,
      //    elevationAppBar: 4.0,
          tittleAppBar: Text("Uni Eats")

      //    enableShadowItensMenu: true,
      //    backgroundMenu: DecorationImage(image: ExactAssetImage('assets/bg_news.jpg'),fit: BoxFit.cover),
    );

  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You must be logged in to be able to purchase and use cart'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
