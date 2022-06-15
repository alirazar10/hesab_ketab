import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class WaterBills extends StatefulWidget {
  WaterBills({Key key}) : super(key: key);

  @override
  _WaterBillsState createState() => _WaterBillsState();
}

class _WaterBillsState extends State<WaterBills> {
  GlobalKey<ScaffoldState> _waterBillScaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext _context;
  Future futureWaterBill;
  var height;
  var width; 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureWaterBill = fetchWaterBill();
  }
  @override
  Widget build(BuildContext context) {
    this._context = context;
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _waterBillScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xC2212121),
        centerTitle: true,
        title: Text('بل‌های آب'),
      ),
      body:Material(
        child: Container(
          child:FutureBuilder(
            future: futureWaterBill,
            // initialData: InitialData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                var data = snapshot.data;
                return Container(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(data[index]['error'] != null && data[index]['error'] == true  ){
                        return  showExceptionMsg(context: this._context, message: data[index]['message']);
                        
                      }

                      List<Widget> _billListWidget = List();
                      if(data[index]['waterbills'].length != 0){
                        print('object in if');
                        var _billData = data[index]['waterbills'];
                        for (var i = 0; i < _billData.length; i++) {
                          print(data);
                          var issueData = _billData[i]['issue_date'];
                          var dueDate = _billData[i]['due_date'];
                          issueData = issueData != null ? DateFormat('y-d-M').format(DateTime.parse(issueData)) : '' ;
                          dueDate = dueDate != null ? DateFormat('y-d-M').format(DateTime.parse(dueDate)) : '' ;

                          _billListWidget.add(
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
                                      child: Text('میتر عمومی: ${data[index]['consumer_name'] + ' / ' +data[index]['subscription_no'].toString()}',
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
                                          child: Text('${_billData[i]['meter_reading_turn']}', style: myTextStyle(color: Color(0xff00BCD4), fontWeight: FontWeight.w500),),
                                        ),
                                        SizedBox(width: 15.0,),
                                        Container(
                                          child: Text('مبلغ تادیه: ', style: myTextStyle(color: Color(0xff00BCD4), fontWeight: FontWeight.w600),),
                                        ),
                                        Container(
                                          
                                          child: _billData[i]['bill_amount'] != null ? 
                                          Text(' ${_billData[i]['bill_amount']}', style: myTextStyle(color: Color(0xff00BCD4), fontWeight: FontWeight.w500),)
                                          :
                                          Text('', style: myTextStyle(color: Color(0xff00BCD4), fontWeight: FontWeight.w500),),
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
                            )
                          );

                          var _neighbor = _billData[i]['neighbor_bills'];
                          print(_neighbor);
                          for (var j = 0; j < _neighbor.length; j++) {
                            print(_neighbor[j]['waterneighbor']['neighbors_name']);
                            _billListWidget.add(
                              Column(
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
                                            child: Text('${_neighbor[j]['waterneighbor']['neighbors_name']}', style: myTextStyle(color: Color(0xFF212121), fontWeight: FontWeight.w500),),
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
                                                    child: Text('${_neighbor[j]['bill_amount'].toInt()}',
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                
                                                Container(child: Text('تعداد ارفراد:  ', style: myTextStyle(),)),
                                                Container(
                                                  child: Text('${_neighbor[j]['people']}'),
                                                ),
                                                Container( 
                                                  height: 20.0,
                                                  child: VerticalDivider(color: Colors.grey, )
                                                ),
                                                Container(child: Text('درجه مصرف شده:  ', style: myTextStyle(),)),
                                                Container(
                                                  child: Text('${_billData[i]['consumed_degree']}'),
                                                ),
                                                
                                              ],
                                            ),
                                            // Divider(thickness: 1.3,),
                                            
                                          ],
                                        ),
                                      ),
                                    )
                                  ),
                                SizedBox(height: 15.0,)

                                ],
                              ),
                            );
                          }

                        }
                      }else{
                        return  showExceptionMsg(context: this._context, message: 'بل پیدا نشد. هنوز بل ثبت نشد. ');
                      }
                      
                      return Material(
                        child: Column(
                          children: _billListWidget,
                        ),
                      );
                    },
                  ),
                );
              }
              return Center(child: CircularProgressIndicator(),);
            },
          ),
        ),
      ),
    );
  }
}