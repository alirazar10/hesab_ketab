import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/appUI/Water_bills.dart';
import 'package:hesab_ketab/appUI/add_electricity_bill.dart';
import 'package:hesab_ketab/appUI/add_water_mater.dart';
import 'package:hesab_ketab/appUI/elec_bill_show.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';

class Home extends StatefulWidget {
  // final Map userData;
  // Home({Key key, this.userData}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var height;
  var width;
  @override
  Widget build(BuildContext context) {
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.width;
    return Material(

        child: Container(
          // padding: EdgeInsets.all(height * 0.02),
          padding: EdgeInsets.only(
            // left: height * 0.022,
            // top: height * 0.04, 
            // right: height * 0.022, 
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),

          height: height,
          width: width,
          child: ListView(
            children: <Widget>[
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Bills()));
                },
                child: Container( 
                  
                  margin:  EdgeInsets.only(
                    top: height * 0.035, 
                    left: height * 0.07, ),
                  padding: EdgeInsets.only(left: height * 0.022 ,top: height * 0.035, right: height * 0.022, bottom: height * 0.035),
                  decoration: BoxDecoration(
                    color: Colors.cyan[300],
                    border: Border.all(
                      color: Color(0xff00BCD4)
                    ),
                    boxShadow: [BoxShadow(color: Colors.grey,  offset: Offset(-5.0, 5.0) ,blurRadius: 6.5, spreadRadius: 0.5,),],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100.0), 
                      topLeft: Radius.circular(100.0),
                      // bottomRight: Radius.circular(8.0), 
                      // topRight: Radius.circular(8.0)
                    )
                  ),
                  child: Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.moneyCheckAlt,
                        size: 55.0,
                        color: Color(0xFFffffff),
                      ),
                      SizedBox(height: height * 0.025,),
                      Text(' بل‌های محاسبه شده برق',
                        style: myTextStyle(fontSize: 20.0, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w700),
                      ),
                    ],
                  )
                )
              ),
              SizedBox(height: height * 0.04,),
              Container(
                  // margin: EdgeInsets.only( right: height*0.022),
                  padding: EdgeInsets.only(left: height * 0.022 ,top: height * 0.035, right: height * 0.022, bottom: height * 0.035),
                decoration: BoxDecoration(
                    color: Color(0xFFFF5622),
                    border: Border.all(
                      color: Color(0xFFFF5722)
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.grey,  offset: Offset(5-.0, 5.0) ,blurRadius: 6.5, spreadRadius: 0.5,),
                      // BoxShadow(color: Colors.grey,  offset: Offset(-2.0,2.0) ,blurRadius: 6.5, spreadRadius: 0.5,),
                      // BoxShadow(color: Colors.grey,  offset: Offset(2.0, 2.0) ,blurRadius: 6.5,  spreadRadius: 0.5,),
                    ],
                    borderRadius: BorderRadius.only(
                      // bottomLeft: Radius.circular(8.0), 
                      // topLeft: Radius.circular(8.0),
                      // bottomRight: Radius.circular(100.0), 
                      // topRight: Radius.circular(100.0)
                    )
                  ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      elevation: 8.0,
                      padding: EdgeInsets.all(10.0),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddElectricityBill()));
                      }, 
                      child: Text('ثبت بل برق', style: myTextStyle(color: Colors.white),),
                      color: Color(0xFFFF5722),
                    ),
                    RaisedButton(
                      elevation: 8.0,
                      padding: EdgeInsets.all(10.0),
                      onPressed: (){
                        print('pressed');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Addwatermeter()));
                        
                      }, 
                      child: Text('ثبت بل آب', style: myTextStyle(color: Colors.white),),
                      color: Color(0xFFFF5722),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.04,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WaterBills()));
                  
                },
                child: Container( 
                  
                  margin:  EdgeInsets.only(left: height * 0.07, ),
                  padding: EdgeInsets.only(right: height * 0.022 ,top: height * 0.035, left: height * 0.022, bottom: height * 0.035),
                  decoration: BoxDecoration(
                    color: Colors.cyan[300],
                    border: Border.all(
                      color: Color(0xff00BCD4)
                    ),
                    boxShadow: [BoxShadow(color: Colors.grey,  offset: Offset(-5.0, 5.0) ,blurRadius: 6.5, spreadRadius: 0.5,),],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100.0), 
                      topLeft: Radius.circular(100.0),
                      // bottomRight: Radius.circular(8.0), 
                      // topRight: Radius.circular(8.0)
                    )
                  ),
                  child: Column(
                    children: [
                      Text(' بل‌های محاسبه شده آب',
                        style: myTextStyle(fontSize: 20.0, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: height * 0.025,),
                      Icon(
                        FontAwesomeIcons.handHoldingUsd,
                        size: 55.0,
                        color: Color(0xFFffffff),
                        // color: Color(0xFF495057),
                        
                      ),
                    ],
                  )
                )
              ),
              SizedBox(height: height * 0.04,),

              

            ],
          ),
        )
    );
  }
}