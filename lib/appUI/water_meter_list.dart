import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class Watermeterlist extends StatefulWidget {
  Watermeterlist({Key key}) : super(key: key);

  @override
  _WatermeterlistState createState() => _WatermeterlistState();
}

class _WatermeterlistState extends State<Watermeterlist> {
  BuildContext _context;
  GlobalKey<ScaffoldState> _waterMeterListScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _editWaterFromKey = GlobalKey<FormState>();
  Future _futureWaterMeter;
  TextEditingController _consumerNameController = TextEditingController();
  TextEditingController _subscriptionNoController = TextEditingController();
  TextEditingController _meterDegreeController = TextEditingController();
  TextEditingController _costPermeterController = TextEditingController();
  DateTime _mySelectedDate;

  var height;
  var width;  
  @override
  void initState() {
    super.initState();
    _futureWaterMeter = fetchWaterMeter();
  }
  @override
  Widget build(BuildContext context) {
    this._context = context;
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _waterMeterListScaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xC2212121),
        title: Text('لیست میترهای آب'),
        centerTitle: true,
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.only(top: height*0.012, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: FutureBuilder(
          future: _futureWaterMeter,
          // initialData: InitialData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              var data = snapshot.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {

                  if(data[index]['error'] != null && data[index]['error'] == true  ){
                    return  showExceptionMsg(context: this._context, message: data[index]['message']);
                    
                  }

                  var status = snapshot.data[index]['status'];
                  
                  return Material(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F0F0),
                            boxShadow: boxShadow(),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,    
                            children: [
                              Text(
                                '${data[index]['consumer_name']} ',
                                style: myTextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              ),

                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          // color: Colors.white,
                                          width: width * 0.7,
                                          child: Column(
                                            children: [
                                              Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('شماره ثبت'),
                                                Text('${data[index]['subscription_no']}'),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('درجه میتر'),
                                                Text('${data[index]['meter_degree']}'),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('قیمت فی متر آب'),
                                                Text('${data[index]['cost_perdegree']}'),
                                              ],
                                            )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 70,
                                          child: VerticalDivider(thickness: 2.0,),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          // color: Colors.red,
                                          width: width - width* 0.82,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                color: Color(0xff00BCD4),
                                                icon: Icon(FontAwesomeIcons.edit),
                                                onPressed: (){
                                                  Map dataToEdit = {
                                                    'id' : data[index]['id'],
                                                    'user_id': data[index]['user_id'],
                                                    'consumer_name':data[index]['consumer_name'],
                                                    'subscription_no':data[index]['subscription_no'],
                                                    'meter_degree':data[index]['meter_degree'],
                                                    'cost_perdegree':data[index]['cost_perdegree'],
                                                    'date' : DateFormat('y-M-d').format(DateTime.parse(data[index]['date']))
                                                  };
                                                  editWaterInfo( _context, _waterMeterListScaffoldKey, dataToEdit);
                                                  print(data[index]['user_id']);
                                                }
                                              ),
                                              IconButton(
                                                color: Colors.red,
                                                icon: Icon(FontAwesomeIcons.times),
                                                onPressed: (){

                                                  myDelete(context: _context, scaffoldKey: _waterMeterListScaffoldKey, meterID: data[index]['id']);
                                                  print('pressed');
                                                }
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ), 
                                    // SizedBox(height: height * 0.012),
                                    Divider(),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Text('', style: myTextStyle(color: Colors.grey[600], fontSize: 12.0),),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                              Text('وضعیت میتر: ', style: myTextStyle(color: Colors.grey[600], fontSize: 12.0)),
                                              status == 1 ? 
                                              Text('فعال', style: myTextStyle(color: Color(0x9100BBD4))) : 
                                              Text('غیر فعال', style: myTextStyle(color: Color(0x91FF5622))),
                                            ],),
                                            
                                            Text( 'تاریخ ثبت: ${DateFormat('y-M-d').format(DateTime.parse(data[index]['date']))}', style: myTextStyle(color: Colors.grey[600], fontSize: 12.0)),
                                            
                                          ],
                                        ),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            primary: Color(0xFFFF5722),
                                          ),
                                          
                                          onPressed: (){
                                            var st = status == 1 ? 0 : 1;
                                            
                                            setState(() {
                                              changeWaterMeterStatus( _context, _waterMeterListScaffoldKey, data[index]['id'], st);
                                              _futureWaterMeter = fetchWaterMeter();
                                            });
                                          },
                                          child: Text('تغیر وضعیت', style: myTextStyle(color: Color(0xff00BCD4), fontSize: 12.0),)
                                        ) 
                                      ],
                                    )
                                  ],
                                ),
                              )
                              
                            ],
                          )
                        ),
                        Divider(thickness: 2.0,),
                        SizedBox(height: height * 0.012,)
                      ],
                    )
                  );
                },
              );

            }else if(snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
  
  editWaterInfo( BuildContext context, scaffoldKey ,Map dataToEdit){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return  AlertDialog(
        elevation: 10.0,
        titleTextStyle:  myTextStyle(color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.bold,),
        title: Text('ویرایش میتر اب'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key:_editWaterFromKey,
                child: Column(
                  children: [
                    Container(
                      child: TextFormField(
                        controller: _consumerNameController..text = dataToEdit['consumer_name'],
                        decoration: myInputDecoration(labelText: 'اسم مشترک', helperText: 'اسم مشترک در بل'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: Color(0xFF212121)),
                        // ignore: missing_return
                        validator: (value){
                          if(value.isEmpty){
                            return 'اسم مشترک را وارد نمایید.';
                          }
                        },
                      )
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      child: TextFormField(
                        controller: _subscriptionNoController..text = dataToEdit['subscription_no'].toString(),
                        decoration: myInputDecoration(labelText: 'شماره ثبت بل'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: Color(0xFF212121)),
                        // ignore: missing_return
                        validator: (value){
                          if(value.isEmpty){
                            return 'شماره ثبت بل را وارد نمایید.';
                          }
                        },
                      )
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      child: TextFormField(
                        controller: _meterDegreeController..text = dataToEdit['meter_degree'].toString(),
                        decoration: myInputDecoration(labelText: 'درجه میتر', helperText: 'اخرین درجه حالیه در بل'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: Color(0xFF212121)),
                        // ignore: missing_return
                        validator: (value){
                          if(value.isEmpty){
                            return 'درجه بل را وارد نمایید';
                          }
                        },
                      )
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      child: TextFormField(
                        controller: _costPermeterController..text = dataToEdit['cost_perdegree'].toString(),
                        decoration: myInputDecoration(labelText: 'قیمت فی متر آب'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        style: myTextStyle(color: Color(0xFF212121)),
                        // ignore: missing_return
                        validator: (value){
                          if(value.isEmpty){
                            return 'قیمت فی متر اب را وارد نمایید.';
                          }
                        },
                      )
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      child: MyTextFieldDatePicker(
                      
                      labelText: "تاریخ",
                      prefixIcon: Icon(Icons.date_range),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      lastDate: DateTime.now().add(Duration(days: 366)),
                      firstDate: DateTime.now().subtract(Duration(days: 366)),
                      initialDate: DateTime.now().add(Duration(days: 1)),
                      userDate: DateTime.parse(dataToEdit['date']),
                      onDateChanged: (selectedDate) {
                        // Do something with the selected date
                        _mySelectedDate = selectedDate;
                        print(_mySelectedDate);
                      },
                    ),
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      child: RaisedButton(
                        color: Color(0xFFFF5722),
                        child: Text('ویرایش میتر'),
                        onPressed: ()async{
                          if(_editWaterFromKey.currentState.validate()){
                            _editWaterFromKey.currentState.save();
                            Map<String, dynamic> _dataToSend = {
                              'id' : dataToEdit['id'].toString(),
                              'user_id': dataToEdit['user_id'].toString(),
                              'consumer_name': _consumerNameController.text,
                              'subscription_no': _subscriptionNoController.text,
                              'meter_degree': _meterDegreeController.text,
                              'cost_perdegree' : _costPermeterController.text,
                              'date': _mySelectedDate != null ? _mySelectedDate.toString() : dataToEdit['date']  
                            };
                            setState(() {
                              editWaterMeter(_context, scaffoldKey, _dataToSend );
                              _futureWaterMeter = fetchWaterMeter();
                              Navigator.of(context, rootNavigator: true).pop();

                            });
                          }
                        }
                      )
                    )

                  ],
                )
              )
            ],
          ),
        ),
        
      );
      }
    );
  }

  myDelete({BuildContext context, scaffoldKey , meterID}){
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
                  RaisedButton(
                    color: Colors.red,
                    child: Text('حذف', style: myTextStyle(color: Colors.white, fontSize: 16.0,)),
                    onPressed: (){
                      print(_waterMeterListScaffoldKey);
                      setState(() {
                        deleteWaterMeter(context, _waterMeterListScaffoldKey, meterID);
                        _futureWaterMeter = fetchWaterMeter();
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                    }
                  ),
                  // SizedBox(width: 25,),
                  RaisedButton(
                    color: Color(0xff00BCD4),
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