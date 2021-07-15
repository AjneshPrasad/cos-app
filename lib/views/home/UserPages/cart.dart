import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos/Services/database.dart';
import 'package:cos/views/home/UserPages/CheckoutPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';


class Cart extends StatefulWidget{
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  QuerySnapshot items;
  QuerySnapshot payroll;
  QuerySnapshot user;
  QuerySnapshot dish;
  String img;

  int Total= 0;
  int radioValue = 1;
  int radioPay = 1;
  String address;
  String Custom='';
  DatabaseService databaseService = new DatabaseService();
  FirebaseStorageService firebaseStorageService = new FirebaseStorageService();
  String _hour, _minute, _time;

  int counts=0;
  String payment;
  String payment2;
  String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  final FirebaseAuth _auth= FirebaseAuth.instance;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }
  @override
  void initState() {
    databaseService.getData('Southern Cross').then(
            (results){
          setState(() {
            dish = results;
          });
        }
    );
    databaseService.getData('User Cart').then(
            (results){
          setState(() {
            items = results;
          });
        }
    );
    databaseService.getData('User').then(
            (results){
          setState(() {
            user = results;
          });
        }
    );
    databaseService.getData('Payroll deduction users').then(
            (results){
          setState(() {
            payroll = results;
          });
        }
    );
    //calTotal();
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    if(items != null){
      return LayoutBuilder(
          builder: (context, costr) {
            var count= 4;
            if(costr.maxWidth > 1200) count= 8;
            else if(costr.maxWidth<700) count=1;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueGrey,
                actions: [
                  Padding(padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: (){

                        checkEligibility();
                        Map check = {
                          'userId':_auth.currentUser.uid,'Date':_dateController.text,'Time':_timeController.text,
                          'DeliveryLoc':address,'Total':Total,'payment method':payment,'TransNo':dish.docs[2].id,'Custom':Custom
                        };
                        databaseService.checkout(check);

                      },
                      child: const Text("Proceed to Checkout",style:TextStyle(color:Colors.white),),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Text(
                              "My Cart",
                              style: TextStyle(
                                //fontWeight:FontWeight.bold,
                                fontSize: 32.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Dish name',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Unit Price',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Quantity',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Subtotal',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Delete',style:TextStyle(fontWeight: FontWeight.bold)),

                          ],
                        ),
                      ),
                      SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.tealAccent.shade100,
                                  borderRadius: BorderRadius.circular(20.0)
                              ),

                              height:costr.maxHeight/2 ,
                              width: costr.maxWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ListView.builder(
                                      itemCount: items.docs.length,
                                      itemBuilder: (context,index){
                                        Total=0;
                                        if(items.docs[index].get('UserId')==_auth.currentUser.uid){
                                            Total=items.docs[index].get('subtotal');
                                            counts =items.docs[index].get('quantity');
                                          int subtotal=items.docs[index].get('subtotal');
                                          return Card(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:[
                                                  Text('${items.docs[index].get('item')}'),
                                                  Text('\$${items.docs[index].get('unit price')}'),
                                                  Text('${items.docs[index].get('quantity')}'),
                                                  Text('\$${subtotal}'),
                                                  IconButton(
                                                    icon: Icon(Icons.delete,size: 30,),
                                                    onPressed: (){
                                                      setState(() {
                                                        databaseService.DeleteCart(items.docs[index].id);
                                                        initState();
                                                      });
                                                    },
                                                  ),
                                                ],
                                              )
                                          );
                                        }
                                        else{
                                          return Container(

                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                      Row(
                        children: [
                          Text('Total:',textAlign:TextAlign.right,
                              style:TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.redAccent)),
                          Text('\$${items.docs[2].get('subtotal')}',textAlign:TextAlign.right,
                              style:TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.redAccent))
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text('Custom meal order option:',style:TextStyle(fontSize: 18),),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Custom Order',
                                helperText: 'can range from ingredients to add or remove in a particular dish, whether you would like a certain condiment alongside your dish etc',
                                labelText: 'Anything else you want to add or customise to your order?'
                            ),
                            maxLines: 3,
                            onChanged: (val){
                              setState(() =>Custom=val);
                            },
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text('Order Instruction:',style:TextStyle(fontSize: 18),),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Radio(value: 1, groupValue: radioValue, onChanged: (T){
                                setState(() {
                                  radioValue = T;
                                  //Total=0;
                                });
                              }),
                              Text('Pickup'),
                              Radio(value: 2, groupValue: radioValue, onChanged: (T){
                                setState(() {
                                  radioValue = T;
                                  //Total=0;
                                });
                              }),
                              Text('Delivery'),
                            ],
                          )
                        ],
                      ),
                      Container(
                        child:form(),
                      ),

                    ],
                  ) ,
                )
              )

            );
          }
      );
    }
    else{
      return Container(
        color: Colors.white30,
        child: Center(
          child: SpinKitChasingDots(
            color: Colors.blueAccent,
            size: 50.0,
          ),
        ),
      );
    }
  }

  Widget form(){
    if(radioValue==1){
      address='Pickup';
     return SingleChildScrollView(
       child: Column(
         children: [
           SizedBox(
             height: 10,
           ),
           Row(
             children: [
               Text('Time:'),
               Container(
                 decoration: BoxDecoration(
                     border: Border.all(color: Colors.grey)
                 ),
                 child: Text('${_timeController.text}'),
               ),
               ElevatedButton(
                   onPressed: (){
                     _selectTime(context);
                   },
                   child: Text('Choose'))
             ],
           ),
           SizedBox(
             height: 10,
           ),
           Row(
             children: [
               Text('Date:'),
               Container(
                 decoration: BoxDecoration(
                     border: Border.all(color: Colors.grey)
                 ),
                 child: Text('${_dateController.text}'),
               ),
               ElevatedButton(
                   onPressed: (){
                     _selectDate(context);
                   },
                   child: Text('Choose'))
             ],
           ),
           Column(
             children: [
               SizedBox(
                 height: 10,
               ),
               Text('Payment Option'),
               Row(
                 children: [
                   Radio(value: 1, groupValue: radioPay, onChanged: (T){
                     setState(() {
                       radioPay = T;
                       payment='Payroll deduction';
                     });
                   }),
                   Text('Payroll deduction'),
                   Radio(value: 2, groupValue: radioPay, onChanged: (T){
                     setState(() {
                       radioPay = T;
                       payment='Cash';
                     });
                   }),
                   Text('Cash'),
                   Radio(value: 3, groupValue: radioPay, onChanged: (T){
                     setState(() {
                       radioPay = T;
                       payment='Credit Card';
                     });
                   }),
                   Text('Credit Card'),
                 ],
               )
               ,SizedBox(
                 height: 10,
               ),
             ],
           )
         ],

       ),

     );
    }
    else{
      return SingleChildScrollView(
        child:
          Container(
            //width:500,
            //height:100 ,
            child:
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Time:'),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey)
                      ),
                      child: Text('${_timeController.text}'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: (){
                          _selectTime(context);
                        },
                        child: Text('Choose'))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Date:'),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey)
                      ),
                      child: Text('${_dateController.text}'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: (){
                          _selectDate(context);
                        },
                        child: Text('Choose'))
                  ],
                ),SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Text('Delivery location:',style:TextStyle(fontSize: 18),),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter address',
                      ),
                      maxLines:2,
                      onChanged: (val){
                        setState(() =>address=val);
                      },
                    )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('Payment Option'),
                    Row(
                      children: [
                        Radio(value: 1, groupValue: radioPay, onChanged: (T){
                          setState(() {
                            radioPay = T;
                            payment='Payroll deduction';
                          });
                        }),
                        Text('Payroll deduction'),
                        Radio(value: 2, groupValue: radioPay, onChanged: (T){
                          setState(() {
                            radioPay = T;
                            payment='Cash';
                          });
                        }),
                        Text('Cash'),
                        Radio(value: 3, groupValue: radioPay, onChanged: (T){
                          setState(() {
                            radioPay = T;
                            payment='Credit Card';
                          });
                        }),
                        Text('Credit Card'),
                      ],
                    )
                    ,SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],

            ),

          ),
      );
    }
  }

  Future<void> checkEligibility() async {

    if(radioPay == 1){
      payment='Payroll deduction';
        _registerPayroll();

    }
    else if(radioPay == 3){
      payment='Credit card';
      redirectToCheckout(context);
    }
    else{
      payment='Cash';
    }
  }
  Future<void> _registerPayroll() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('you are not registerd to the payroll deduction option,register Now?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                  dynamic request = {
                    'userId':_auth.currentUser.uid,'empId':user.docs[0].get('empId'),'empFname':user.docs[0].get('First name'),
                    'empLname':user.docs[0].get('Surname'),'empEmail':user.docs[0].get('email'),'empPhone':user.docs[0].get('mobile'),
                  };
                  databaseService.Payrollregister(request);

                  Navigator.of(context).pop();
                }

            ),
            TextButton(
              child: Text('No'),
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

