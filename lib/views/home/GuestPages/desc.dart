import 'package:cos/Services/database.dart';
import 'package:cos/views/auth/register.dart';
import 'package:cos/widgets/NavigationBar/nav_bar_guest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductDetailScreen extends StatefulWidget {
  final String dishname;
  final double price;
  final String img;
  final String desc;

  const ProductDetailScreen({Key key, this.dishname, this.price, this.img, this.desc}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  FirebaseStorageService firebaseStorageService = new FirebaseStorageService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Stack(
            children:[
              IconButton(icon: const Icon(Icons.home,size: 30,),
                  onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CollapsingNavigationDrawerGuest()));
                  }
              )
            ]
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          Padding(padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
              },
              child: const Text("Register",style:TextStyle(color:Colors.white),),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.dishname),
              background: FutureBuilder(
                future: firebaseStorageService.getImage(context,widget.img),
                builder: (context,snapshot){
                  if (snapshot.connectionState== ConnectionState.done){
                    return Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      height:MediaQuery.of(context).size.height/1.2 ,
                      child: snapshot.data,
                    );
                  }
                  if (snapshot.connectionState== ConnectionState.waiting){
                    return Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      height:MediaQuery.of(context).size.height/1.2 ,
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),
              Text( '\$${widget.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.desc,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 800)
            ]),
          ),
        ],
      ),
    );
  }
}