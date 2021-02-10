import 'package:flutter/material.dart';

import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class Bills extends StatefulWidget {
  Bills({Key key}) : super(key: key);

  @override
  _BillsState createState() => _BillsState();
}



class _BillsState extends State<Bills> {
  BuildContext _context; 
  Future _fetchBill;
  var height;
  var width;

  @override
  void initState() {
    super.initState();
    _fetchBill = fetchBills();
  }
  @override
  Widget build(BuildContext context) {
    _context = context;
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text('بل‌های محاسبه شده'),
      ),
      body: Material(
        child: Container(
          height: height,
          width: width,
          // padding: EdgeInsets.all(height * 0.012),
          child: FutureBuilder(
            future: _fetchBill,
            // initialData: InitialData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                var data = snapshot.data;

                
                return Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(data[index]['error'] != null && data[index]['error'] == true  ){
                        return  showExceptionMsg(context: this._context, message: data[index]['message']);
                      }
                      if(snapshot.data[index]['electricitybills'].length != 0){
                        var _bills = snapshot.data[index]['electricitybills'];
                        List<Widget> _billWidget = List<Widget>(); 
                        for(var i = 0; i < _bills.length; i++){
                          var issueData = _bills[i]['issue_date'];
                          var dueDate = _bills[i]['due_date'];
                           issueData = DateFormat('y-d-M').format(DateTime.parse(issueData));
                           dueDate = DateFormat('y-d-M').format(DateTime.parse(dueDate));
                          _billWidget.add(
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 15.0,top: 10.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.cyan[50],
                                boxShadow: boxShadow()
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 15.0),
                                    // color: Colors.grey[300],
                                    alignment: Alignment.center,
                                    child: Text('میتر عمومی: ${snapshot.data[index]['consumer_name'] + ' / ' +snapshot.data[index]['no_of_submeters'].toString()}',
                                    style: myTextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text('دوره بل: ', style: myTextStyle(color: Color(0xff00BCD4), fontSize: 16.0, fontWeight: FontWeight.w600),),
                                      ),
                                      Container(
                                        child: Text('${_bills[i]['meter_reading_turn']}', style: myTextStyle(color: Color(0xff00BCD4), fontWeight: FontWeight.w500),),
                                      ),
                                      SizedBox(width: 15.0,),
                                      Container(
                                        child: Text('مبلغ تادیه: ', style: myTextStyle(color: Color(0xff00BCD4), fontWeight: FontWeight.w600),),
                                      ),
                                      Container(
                                        child: Text(' ${_bills[i]['bill_amount']}', style: myTextStyle(color: Color(0xff00BCD4), fontWeight: FontWeight.w500),),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top:10.0, bottom: 10.0),
                                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0 ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.cyan[100],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // SizedBox(width: 15.0,),
                                        Container(
                                          child: Text('تاریخ صدور: ', style: myTextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),),
                                        ),
                                        Container(
                                          child: Text(' $issueData', style: myTextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),),
                                        ),
                                        VerticalDivider(),
                                        Container(
                                          child: Text('تاریخ مهلت: ', style: myTextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),),
                                        ),
                                        Container(
                                          child: Text(' $dueDate', style: myTextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          );
                          
                          // _billWidget.add(
                            
                          // );
                          // _billWidget.add(
                          //   Container( 
                          //     color: Color(0xFFDDDDDD),
                          //     padding: EdgeInsets.all(10.0),
                          //     alignment: Alignment.centerRight,
                          //     child: Text('میترهای فرعی', 
                          //       style: myTextStyle(color: Color(0xFF212121)
                          //       , fontWeight: FontWeight.w500),
                          //     )
                          //   )
                          // );
                          
                          var _subMetDegr = _bills[i]['submeterdegrees'];
                          for(var j=0; j< _subMetDegr.length; j++){
                            _billWidget.add(Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Container(
                                  padding: EdgeInsets.only(bottom:10.0),
                                  decoration: BoxDecoration(
                                    boxShadow: boxShadow(),
                                    color: Color(0xFFF0F0F0)
                                  ),
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          // color: Color(0x7500BBD4),
                                          // padding: EdgeInsets.all(8.0),
                                          child: Text('${_bills[i]['submeterdegrees'][j]['submeter']['submeter_consumer']}', style: myTextStyle(color: Color(0xFF212121), fontWeight: FontWeight.w500),),
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(top: 10.0 ,bottom: 20.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.cyan[50],
                                                    boxShadow: boxShadow(),
                                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(50.0), topRight: Radius.circular(50.0) ),

                                                  ),
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('مبلغ تادیه', style: myTextStyle(color: Color(0xff212121), fontSize: 14),)
                                                ),
                                                Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(5.0),
                                                constraints: BoxConstraints(minWidth: 70.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFF5722),
                                                    boxShadow: boxShadow(),
                                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), topLeft: Radius.circular(50.0) ),

                                                  ),
                                                  child: Text('${_bills[i]['submeterdegrees'][j]['bill_amount'].toInt()}',
                                                  style: myTextStyle(fontSize: 18.0,color: Color(0xffffffff), fontWeight: FontWeight.w700
                                                  )),
                                                ),
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                    
                                    subtitle: Container(
                                      // height: 30.0,
                                      
                                      padding: EdgeInsets.only(left:8.0, top:8.0, right: 8.0, bottom: 15.0),

                                      child: Column(
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                
                                                Container(child: Text('درجه حالیه:  ', style: myTextStyle(),)),
                                                Container(
                                                  child: Text('${_bills[i]['submeterdegrees'][j]['current_degree']}'),
                                                ),
                                                Container( 
                                                  height: 20.0,
                                                  child: VerticalDivider(color: Colors.grey, )
                                                ),
                                                Container(child: Text('درجه مصرف شده:  ', style: myTextStyle(),)),
                                                Container(
                                                  child: Text('${_bills[i]['submeterdegrees'][j]['consumed_degree']}'),
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                          // Divider(thickness: 1.3,),
                                          
                                        ],
                                      ),
                                    ),
                                    
                                  ),
                                ),
                                
                                SizedBox(height: 15.0,)
                              ],
                            ),
                            );
                          }
                          
                          
                          _billWidget.add(
                            Divider(thickness: 2, color: Colors.grey)
                          );
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            // Divider(),
                            Column(
                              children: 
                                _billWidget
                            )
                          ],
                        );
                      }
                      else{
                        return Container();
                      }
                      
                    },
                  ),
                );
              }else if(snapshot.hasError){
                return Text('${snapshot.hasError}');
              }
              return Center(child: CircularProgressIndicator(),);

            },
          ),
        ),
      ),
    );
  }
}