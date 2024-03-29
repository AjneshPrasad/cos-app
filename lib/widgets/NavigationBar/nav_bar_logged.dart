import 'package:cos/Services/auth.dart';
import 'package:cos/views/auth/login.dart';
import 'package:cos/views/auth/register.dart';
import 'package:cos/views/home/UserPages/cart.dart';
import 'package:cos/views/home/UserPages/homeviewLogged.dart';
import 'package:cos/views/home/UserPages/hotbreadLogged.dart';
import 'package:cos/widgets/NavigationBar/nav_bar_guest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class CollapsingNavigationDrawerUser extends StatefulWidget {

  @override
  CollapsingNavigationDrawerUserState createState() {
    return new CollapsingNavigationDrawerUserState();
  }
}

class CollapsingNavigationDrawerUserState extends State<CollapsingNavigationDrawerUser>
    with SingleTickerProviderStateMixin {
  List<ScreenHiddenDrawer> itens = [];
  final AuthService _auth = AuthService();
  final FirebaseAuth _auth2= FirebaseAuth.instance;


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
            child: ElevatedButton.icon(
              icon: Icon(
                Icons.person,
                color: Colors.blueGrey,
                size: 24.0,
              ),
              onPressed: ()async{
              dynamic  result=await _auth.signOut();

              if(result== null){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CollapsingNavigationDrawerGuest()));
              }
              else{

              }
              },
              label: Text("Log Out",style:TextStyle(color:Colors.white),),
            ),
          ),


          Container(
            padding:const EdgeInsets.all(10) ,
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart,size: 30,),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Cart()));
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

}
