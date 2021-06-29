import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class WaterNeighborList extends StatefulWidget {
  WaterNeighborList({Key key}) : super(key: key);

  @override
  _WaterNeighborListState createState() => _WaterNeighborListState();
}

class _WaterNeighborListState extends State<WaterNeighborList> {
  BuildContext _context;
  GlobalKey<ScaffoldState> _neighborListScaffoldKey = GlobalKey<ScaffoldState>();
  Future _futureNeighbor;
  var height;
  var width;
  var bottomInset;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureNeighbor = fetchWaterNeighbor();
  }
  @override
  Widget build(BuildContext context) {
    _context= context;
    this.width = MediaQuery.of(context).size.width;
    this.height = MediaQuery.of(context).size.height;
    this.bottomInset = MediaQuery.of(context).viewInsets.bottom;
    var _padding = EdgeInsets.only(
      // left: this.height * 0.012,
      top: this.height * 0.012,
      // right: this.height * 0.012,
      bottom: this.bottomInset,
    );
    return Scaffold(
      key: _neighborListScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xC2212121),
        centerTitle: true,
        title: Text('همسایه‌های شریک در آب'),
      ),
      body: Container(
        padding: _padding,
        child: FutureBuilder(
          future: _futureNeighbor,
          // initialData: 'asdf',
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              var data = snapshot.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  if(data[index]['error'] != null && data[index]['error'] == true  ){
                    return  showExceptionMsg(context: this._context, message: data[index]['message']);
                  }

                  var neighbors = data[index]['waterneighbors'];
                  List<TableRow> _tableRow = []; 
                  _tableRow.add(TableRow(
                    children: [
                      Text('نام میتر', style: myTextStyle( fontWeight: FontWeight.w600),),
                      Text('تعداد افراد', style: myTextStyle( fontWeight: FontWeight.w600)),
                      Text('درجه میتر', style: myTextStyle( fontWeight: FontWeight.w600)),
                      Text('تاریخ ثبت', style: myTextStyle( fontWeight: FontWeight.w600)),
                      Text('', style: myTextStyle( fontWeight: FontWeight.w600)),
                    ]
                  ));

                  for (var i = 0; i < neighbors.length; i++) {
                     _tableRow.add(TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${neighbors[i]['neighbors_name']}',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${neighbors[i]['meter_degree']}',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${neighbors[i]['people']}',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${ DateFormat('y-M-d').format(DateTime.parse(neighbors[i]['date'])).toString() }',
                          ),
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.times),
                          color: Colors.red,
                          splashRadius: 15.0,
                          visualDensity: VisualDensity(vertical: -4, horizontal: 0),
                          iconSize: 16, padding: EdgeInsets.all(0.0),
                          onPressed: (){
                            print(neighbors[i]['id']);
                            myDelete( context: _context, meterID: neighbors[i]['id']);
                          }
                        ),
                      ]
                    ));
                  }
                  return Column(
                    children: [
                      Container(
                        width: width,
                        padding: EdgeInsets.all( height * 0.012),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F0F0),
                          boxShadow: boxShadow(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'میتر عمومی: ',
                                  style: myTextStyle(fontSize: 16, fontWeight: FontWeight.w700 ),
                                ),
                                Text(
                                  '${data[index]['consumer_name']} - ${data[index]['subscription_no']}',
                                  style: myTextStyle(fontSize: 16, fontWeight: FontWeight.w500 ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: width,
                                    color: Colors.grey[300],
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('مصرف کننده‌ها',
                                      style: myTextStyle(fontSize: 14, fontWeight: FontWeight.w500 )
                                    ),
                                  ),
                                  Table(
                                    // columnWidths: {1: FlexColumnWidth(3.0) },
                                    children: _tableRow,
                                    
                                  ),
                                ],
                              )
                            ),

                          ],
                        ),
                      ),
                      Divider(thickness: 2.0,),
                      SizedBox(height: height*0.012,),
                      
                    ],
                  );
                },
              );
            }
            return Center(child: RefreshProgressIndicator());
          },
        ),
      ),
    );
  }

  myDelete({BuildContext context, meterID}){
    return showDialog(
      context: context,
      builder: (BuildContext context){
      return AlertDialog(
        actionsPadding: EdgeInsets.all(20) ,
        elevation: 10.0,
        titleTextStyle:  myTextStyle(color: Colors.red, fontSize: 24.0, fontWeight: FontWeight.bold,),
        // title: Text('حذف میتر عمومی!'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Icon(FontAwesomeIcons.exclamationTriangle, size: 70, color: Colors.amberAccent,),
              SizedBox(height: 20.0,),
              Text('میتر عمومی خذف شود؟', style: myTextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold,)),
              SizedBox(height: 40.0,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton (
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: Text('حذف', style: myTextStyle(color: Colors.white, fontSize: 16.0,)),
                    onPressed: (){
                      setState(() {
                        deleteWaterNeighbor(_context, _neighborListScaffoldKey, meterID);
                        _futureNeighbor = fetchWaterNeighbor();
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                    }
                  ),
                  // SizedBox(width: 25,),
                  ElevatedButton (
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xff00BCD4)),
                    ),
                    child: Text('لغو', style: myTextStyle(color: Colors.white, fontSize: 16.0,)),
                    onPressed: (){
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  )
                ],
              )
            ],
          ),
        ),
      );
      }
    );
  }
}