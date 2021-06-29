import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class AddWaterBill extends StatefulWidget {
  AddWaterBill({Key key}) : super(key: key);

  @override
  _AddWaterBillState createState() => _AddWaterBillState();
}

class _AddWaterBillState extends State<AddWaterBill> {
  BuildContext _context;
  GlobalKey<ScaffoldState> _waterBillScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _addWaterBillFormKey = GlobalKey<FormState>();
  var height;
  var width;
  var bottomInset;
  // Future _futureWater;
  List _dropdownItmes = [];
  String _dropdownValue;
  List _neighborInfo = [];
  List<Widget> _children = [];
  Map < String, TextEditingController> _peopleTextFeildController = Map();
  
  TextEditingController _billAmountTEController = TextEditingController();
  TextEditingController _readingTurntTEController = TextEditingController();
  TextEditingController _meterDegreeTEController = TextEditingController();
  TextEditingController _consumedDegreeTEController = TextEditingController();
  TextEditingController _costPermeterTEController = TextEditingController();

  DateTime _mySelectedIssueDate;
  DateTime _mySelectedDueDate;
  var _costPermeter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWaterNeighbor().then((val){
        setState(() {
          this._dropdownItmes = val;
        });
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    _context = context;
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.width;
    this.bottomInset = MediaQuery.of(context).viewInsets.bottom;
    var _padding = EdgeInsets.only(
      left: this.height * 0.012,
      top: this.height * 0.012,
      right: this.height * 0.012,
      bottom: this.bottomInset,
    );
    return Scaffold(
      key: _waterBillScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xC2212121),
        centerTitle: true,
        title: Text('ثبت بل آب'),
      ),
      body:Container(
        height: height,
        padding: _padding,
        child: SingleChildScrollView(
          child: Form(
            key: _addWaterBillFormKey,
            child: Column(
              children: _dropdownItmes.isEmpty ? [ //checks if it has data if yes display loading
                Container(
                  alignment: Alignment.center, height: this.height - 100 ,
                  child: CircularProgressIndicator())
                ] : _dropdownItmes[0]['error'] != null && _dropdownItmes[0]['error'] == true ? [ //check if it hass error if yes show error
                  showExceptionMsg(context: this._context, message: _dropdownItmes[0]['message']),
                  
                ]: [
                DropdownButtonFormField(
                  decoration: myInputDecoration(labelText: 'انتخاب میتر'),
                  style: myTextStyle(color: Color(0xFF212121)),
                  items: _dropdownItmes.map((list){
                    return DropdownMenuItem(
                      child: Text('${list['consumer_name']}'),
                      value: list['id'].toString(),
                      onTap: (){
                        _neighborInfo = list['waterneighbors'];
                        _costPermeter = list['cost_perdegree'];
                      },
                    );
                  }).toList(),
                  onChanged: (value){
                    if(_children.length != 0 ){
                      _children.clear(); // to create new textfields clear list items
                    }
                    _createNeighborTextFeild(_neighborInfo);
                    _dropdownValue = value;
                  },
                  // ignore: missing_return
                  validator: (String value){
                  //  value = '';
                    if(value == null || value.isEmpty){
                      return ' میتر را انتخاب نمایید.';
                    }
                  },
                ),
                
                SizedBox(height: height * 0.012,),
                TextFormField(
                  controller: _readingTurntTEController,
                  decoration: myInputDecoration(labelText: 'دوره'),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  style: myTextStyle(color: Color(0xFF212121)),
                  // ignore: missing_return
                  validator: (value){
                    if(value.isEmpty){
                      return 'دوره را وارد نمایید.';
                    }
                  },
                ),
                SizedBox(height: height * 0.012,),
                // TextFormField(
                //   controller: _billAmountTEController,
                //   decoration: myInputDecoration(labelText: 'مبلغ تادیه'),
                //   keyboardType: TextInputType.text,
                //   textInputAction: TextInputAction.next,
                //   onEditingComplete: () => FocusScope.of(context).nextFocus(),
                //   style: myTextStyle(color: Color(0xFF212121)),
                //   // ignore: missing_return
                //   validator: (value){
                //     if(value.isEmpty){
                //       return 'مبلغ تادیه را وارد نمایید.';
                //     }
                //   },
                // ),
                // SizedBox(height: height * 0.012,),
                
                TextFormField(
                  controller: _meterDegreeTEController,
                  decoration: myInputDecoration(labelText: 'درجه حالیه'),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  style: myTextStyle(color: Color(0xFF212121)),
                  // ignore: missing_return
                  validator: (value){
                    if(value.isEmpty){
                      return 'درجه حالیه را وارد نمایید.';
                    }
                  },
                ),
                SizedBox(height: height * 0.012,),
                TextFormField(
                  controller: _consumedDegreeTEController,
                  decoration: myInputDecoration(labelText: 'درجه مصرف شده'),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  style: myTextStyle(color: Color(0xFF212121)),
                  // ignore: missing_return
                  validator: (value){
                    if(value.isEmpty){
                      return 'درجه مصرف شده را وارد نمایید.';
                    }
                  },
                ),
                SizedBox(height: height * 0.012,),
                TextFormField(
                  controller: _costPermeterTEController..text = _costPermeter != null ? _costPermeter.toString() : '',
                  decoration: myInputDecoration(labelText: 'قیمت فی متر آب'),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  style: myTextStyle(color: Color(0xFF212121)),
                  // ignore: missing_return
                  validator: (value){
                    if(value.isEmpty){
                      return 'مبلغ تادیه را وارد نمایید.';
                    }
                  },
                ),
                SizedBox(height: height * 0.012,),
                MyTextFieldDatePicker(
                      
                  labelText: "تاریخ صدور",
                  prefixIcon: Icon(Icons.date_range),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  lastDate: DateTime.now().add(Duration(days: 366)),
                  firstDate: DateTime.now().subtract(Duration(days: 366)),
                  initialDate: DateTime.now().add(Duration(days: 1)),
                  onDateChanged: (selectedDate) {
                    // Do something with the selected date
                    _mySelectedIssueDate = selectedDate;
                  },
                ),
                SizedBox(height: height * 0.012,),
                MyTextFieldDatePicker(
                      
                  labelText: "تاریخ مهلت",
                  prefixIcon: Icon(Icons.date_range),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  lastDate: DateTime.now().add(Duration(days: 366)),
                  firstDate: DateTime.now().subtract(Duration(days: 366)),
                  initialDate: DateTime.now().add(Duration(days: 1)),
                  onDateChanged: (selectedDate) {
                    // Do something with the selected date
                    _mySelectedDueDate = selectedDate;
                  },
                ),
                SizedBox(height: height * 0.012,),
                Column(
                  children: _children,
                ),
                SizedBox(height: height * 0.022,),
                ElevatedButton (
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF5722)),
                  ),
                  child: Text('ثبت و محاسبه'),
                  onPressed: () async{
                    if(_addWaterBillFormKey.currentState.validate()){
                      _addWaterBillFormKey.currentState.save();
                      Map dataToSend = {
                        'water_id': _dropdownValue,
                        // 'bill_amount': _billAmountTEController.text,
                        'meter_reading_turn': _readingTurntTEController.text,
                        'current_degree': _meterDegreeTEController.text,
                        'consumed_degree': _consumedDegreeTEController.text,
                        'cost_permeter': _costPermeterTEController.text,
                        'issue_date':  _mySelectedIssueDate != null ? _mySelectedIssueDate.toString() : DateFormat('y-M-d').format(DateTime.now()).toString(),
                        'due_date':  _mySelectedDueDate != null ? _mySelectedDueDate.toString() : DateFormat('y-M-d').format(DateTime.now()).toString()
                      };
                      await addWaterBill(context, _waterBillScaffoldKey, _peopleTextFeildController, dataToSend);
                    }

                  }
                )
              ],
            )
          ),
        )
      ),
    );
  }


  _createNeighborTextFeild(neighbor){
    for (var i = 0; i < neighbor.length; i++) {
      print(neighbor[i]['people']);
      _peopleTextFeildController[neighbor[i]['id'].toString()] = TextEditingController();
      _children = List.from(_children)
      ..add(SizedBox(height: height * 0.015,));

      _children = List.from(_children)
      ..add(TextFormField(
        controller: _peopleTextFeildController[neighbor[i]['id'].toString()]..text = neighbor[i]['people'].toString(),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: myInputDecoration(labelText: ' تعداد افراد: ${neighbor[i]['neighbors_name']}'),
        // ignore: missing_return
        validator: (value){
          if(value.isEmpty){
            return '${neighbor[i]['neighbors_name']} را وارد نمایید.';
          }
        },
      ));
      setState(() => i);
    }
  }
}