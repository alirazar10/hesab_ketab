import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/appUI/Water_bills.dart';
import 'package:hesab_ketab/appUI/add_electricity_bill.dart';
import 'package:hesab_ketab/appUI/add_water_bill.dart';
import 'package:hesab_ketab/appUI/add_water_mater.dart';
import 'package:hesab_ketab/appUI/elec_bill_show.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/utils/navigationService.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin:  EdgeInsets.only(
                        top: height * 0.035, 
                        left: height * 0.01,
                        right: height * 0.02,
                        ),
                      padding: EdgeInsets.only(left: height * 0.022 ,top: height * 0.035, right: height * 0.022, bottom: height * 0.035),
                      decoration: BoxDecoration(
                        color: Colors.cyan[300],
                        border: Border.all(
                          color: Color(0xff00BCD4)
                        ),
                        boxShadow: [BoxShadow(color: Colors.grey,  offset: Offset(-5.0, 5.0) ,blurRadius: 6.5, spreadRadius: 0.5,),],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0), 
                          topLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0), 
                          topRight: Radius.circular(8.0)
                        )
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Bills()));
                        },
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.moneyCheckAlt,
                              size: 55.0,
                              color: Color(0xFFffffff),
                            ),
                            SizedBox(height: height * 0.025,),
                            Text(' بل‌های برق',
                              style: myTextStyle(fontSize: 20.0, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin:  EdgeInsets.only(
                        top: height * 0.035, 
                        left: height * 0.02,
                        right: height * 0.01,
                      ),
                      padding: EdgeInsets.only(left: height * 0.022 ,top: height * 0.035, right: height * 0.022, bottom: height * 0.035),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF5722),
                        border: Border.all(
                          color: Color(0xFFFF5722)
                        ),
                        boxShadow: [BoxShadow(color: Colors.grey,  offset: Offset(-5.0, 5.0) ,blurRadius: 6.5, spreadRadius: 0.5,),],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0), 
                          topLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0), 
                          topRight: Radius.circular(8.0)
                        )
                      ),
                      child: InkWell(
                        onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddElectricityBill()));
                          },
                        child: Column(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.plus,
                                size: 55.0,
                                color: Color(0xFFffffff),
                              ),
                            SizedBox(height: height * 0.025,),
                              Text('ثبت بل برق',
                                style: myTextStyle(fontSize: 20.0, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                      ),
                    ),
                  )
                  
                ],
              ),
              
              SizedBox(height: height * 0.04,),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin:  EdgeInsets.only(
                        left: height * 0.02,
                        right: height * 0.01,
                       ),
                      padding: EdgeInsets.only(right: height * 0.022 ,top: height * 0.035, left: height * 0.022, bottom: height * 0.035),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF5722),
                        border: Border.all(
                          color: Color(0xFFFF5722)
                        ),
                        boxShadow: [BoxShadow(color: Colors.grey,  offset: Offset(-5.0, 5.0) ,blurRadius: 6.5, spreadRadius: 0.5,),],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0), 
                          topLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0), 
                          topRight: Radius.circular(8.0)
                        )
                      ),
                      child: InkWell(
                        onTap: (){
                          NavigationService.instance.navigateTo('/waterBills');
                          
                        },
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.handHoldingUsd,
                              size: 55.0,
                              color: Color(0xFFffffff),
                              // color: Color(0xFF495057),
                              
                            ),
                            SizedBox(height: height * 0.025,),
                            Text(' بل‌های  آب',
                              style: myTextStyle(fontSize: 20.0, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin:  EdgeInsets.only(
                        left: height * 0.02,
                        right: height * 0.01,
                      ),
                      padding: EdgeInsets.only(right: height * 0.022 ,top: height * 0.035, left: height * 0.022, bottom: height * 0.035),
                      decoration: BoxDecoration(
                        color: Colors.cyan[300],
                        border: Border.all(
                          color: Color(0xff00BCD4)
                        ),
                        boxShadow: [BoxShadow(color: Colors.grey,  offset: Offset(-5.0, 5.0) ,blurRadius: 6.5, spreadRadius: 0.5,),],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0), 
                          topLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0), 
                          topRight: Radius.circular(8.0)
                        )
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddWaterBill()));
                        },
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.plusSquare,
                              size: 55.0,
                              color: Color(0xFFffffff),
                              // color: Color(0xFF495057),
                              
                            ),
                            SizedBox(height: height * 0.025,),
                            Text('ثبت بل آب', 
                            style: myTextStyle(fontSize: 20.0, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w700)
                            ),
                          ],
                        ),
                      )
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.04,),

              

            ],
          ),
        )
    );
  }
}