import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/appUI/Water_bills.dart';
import 'package:hesab_ketab/appUI/addWaterNeighbor.dart';
import 'package:hesab_ketab/appUI/add_water_mater.dart';
import 'package:hesab_ketab/appUI/water_meter_list.dart';
import 'package:hesab_ketab/appUI/water_neighbor_list.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';

import 'add_water_bill.dart';

class Water extends StatefulWidget {
  Water({Key key}) : super(key: key);

  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  
  @override
  Widget build(BuildContext context) {
    var _paddings = EdgeInsets.only(
                      left:MediaQuery.of(context).size.height * 0.015,
                      top:MediaQuery.of(context).size.height * 0.015,
                      right:MediaQuery.of(context).size.height * 0.015,
                      bottom:MediaQuery.of(context).size.height * 0.015,
                    );
    return Material(
       child: SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Divider(thickness: 3.0,),
              SizedBox(height: 10.0,),
              
              Container(
                padding: _paddings,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(8),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: AlignmentDirectional.bottomEnd, 
                  //   colors: [Color(0xFFFF5722),Color(0xDAF83E14)],),
                  boxShadow: boxShadow(),
                  color: Color(0xFFF0F0F0)
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: iconButtonBackground(color: Color(0x23FF5722), radius: 50.0),
                          child: IconButton(
                            visualDensity: VisualDensity(vertical: 4, horizontal: 4),
                            color: Color(0xFFFF5722),
                            tooltip: 'ثبت میتر آب',
                            hoverColor: Colors.green,
                            icon: Icon( 
                              FontAwesomeIcons.plus, 
                              size: 27.0,
                            ), 
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Addwatermeter()));
                            }
                          ),
                        ),
                        Text('ثبت میتر آب', style: myTextStyle(color: Colors.black, fontSize:17.0),),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          decoration: iconButtonBackground(color: Color(0x2300bcd4), radius: 10.0),
                          child: IconButton(
                            padding: EdgeInsets.all(0.0),
                            visualDensity: VisualDensity(vertical: 0, horizontal: 4),
                            color: Color(0xff00BCD4),
                            tooltip: 'مشاهده میترآب ',
                            hoverColor: Colors.black,
                            icon: Icon( 
                              FontAwesomeIcons.ellipsisH,  
                              size: 24.0,
                            ), 
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Watermeterlist()));
                            }
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Divider(thickness: 3.0, height: 20.0,),
              SizedBox(height: 10.0,),
              Container(
                padding: _paddings,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(8),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: AlignmentDirectional.bottomEnd, 
                  //   colors: [Color(0xFFFF5722),Color(0xDAF83E14)],
                  // ),
                  boxShadow: boxShadow(),
                  color: Color(0xFFF0F0F0),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: iconButtonBackground(color: Color(0x23FF5722), radius: 50.0),
                          child: IconButton(
                            visualDensity: VisualDensity(vertical: 4, horizontal: 4),
                            icon: Icon( FontAwesomeIcons.plus, color: Color(0xFFFF5722), size: 27.0, ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddWaterNeibors()));
                            },
                          ),
                        ),
                        Text('همسایه‌های مشترک درآب', style: myTextStyle(color: Colors.black87, fontSize:17.0),),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          decoration: iconButtonBackground(color: Color(0x2300BCD4), radius: 10.0),
                          child: IconButton(
                            padding: EdgeInsets.all(0.0),
                            visualDensity: VisualDensity(vertical: 0, horizontal: 4),
                            icon: Icon( FontAwesomeIcons.ellipsisH, color: Color(0xff00BCD4), size: 24.0,),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WaterNeighborList()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(thickness: 3.0, height: 20.0,),
              SizedBox(height: 10.0,),

              Container(
                padding: _paddings,
                decoration: BoxDecoration(
                  boxShadow: boxShadow(),
                  color: Color(0xFFF0F0F0)
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ثبت بل و درجه حالیه میترهای فرعی', style: myTextStyle(color: Colors.black, fontSize:17.0, fontWeight: FontWeight.w500),),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.024,),
                          
                        Container(
                          decoration: iconButtonBackground(color: Color(0x23FF5722), radius: 50.0),
                          child: IconButton(
                            padding: EdgeInsets.all(15.0),
                            visualDensity: VisualDensity(horizontal: 4, vertical: 4),
                            iconSize: 50.0,
                            
                            icon: Icon( FontAwesomeIcons.plus, color: Color(0xFFFF5722),  ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddWaterBill()));
                              
                            },
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.018,),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.018,),

                        Container(
                          height: 25,
                          width: 60,
                          decoration: iconButtonBackground(color: Color(0x2300BCD4), radius: 10.0),
                          child: IconButton(
                            padding: EdgeInsets.all(0.0),
                            visualDensity: VisualDensity(horizontal: 0, vertical: 4),
                            iconSize: 24,
                            icon: Icon( FontAwesomeIcons.ellipsisH, color: Color(0xff00BCD4),),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WaterBills()));
                              
                            },
                          ),
                        ),
                        

                        // SizedBox(height: MediaQuery.of(context).size.height * 0.018,),
                        
                        
                        SizedBox(height: MediaQuery.of(context).size.height * 0.018,)
                      ],
                    ),
                  ),
                ),
              ),
              Divider(thickness: 3.0, height: 20.0,),

            ],
         ),
       ),
    );
  }
}