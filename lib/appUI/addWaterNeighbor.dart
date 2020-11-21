import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/myWidgets/cost_widges.dart';
import 'package:hesab_ketab/myWidgets/date_time_picker.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class AddWaterNeibors extends StatefulWidget {
  AddWaterNeibors({Key key}) : super(key: key);

  @override
  _AddWaterNeiborsState createState() => _AddWaterNeiborsState();
}

class _AddWaterNeiborsState extends State<AddWaterNeibors> {
  var height;
  var width;
  var _bottomInset;
  DateTime _mySelectedDate;
  List _dropdownItmes = List();
  String _dropdownValue;
  BuildContext _context;
  GlobalKey<ScaffoldState> _neighnorScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _neighnorFormKey = GlobalKey<FormState>();
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _peopleTextEditingController = TextEditingController();
  TextEditingController _degreeTextEditingController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    fetchWaterMeter().then((val){
      print(val);
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
    this._bottomInset = MediaQuery.of(context).viewInsets.bottom;
    var _padding = EdgeInsets.only(
          left: height * .012,
          top: height * .012,
          right: height * .012,
          bottom: this._bottomInset
        );
       
       
    return Scaffold(
      key: _neighnorScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xC2212121),
        centerTitle: true,
        title: Text('اضافه کردن همسایه‌ها'),
      ),
      body: Container(
        padding: _padding,
        child: Form(
          key: _neighnorFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:  _dropdownItmes.isEmpty ? [ //checks if it has data if yes display loading
                Center(child: CircularProgressIndicator())
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
                    );
                  }).toList(), 
                  onChanged: (value) { 
                    setState(() {
                      this._dropdownValue = value;
                    });
                  },
                  // ignore: missing_return
                  validator: (String value){
                    if(value == null || value.isEmpty){
                      return ' میتر را انتخاب نمایید.';
                    }
                  },
                ),
                SizedBox(height: height*.012,),
                TextFormField(
                  controller: _nameTextEditingController,
                  decoration: myInputDecoration(labelText: 'نام گذاری'),
                  style: myTextStyle(color: Color(0xFF212121)),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  // ignore: missing_return
                  validator: (String value){
                    if(value == null || value.isEmpty){
                      return ' نام را وارد نمایید.';
                    }
                  },
                ),
                SizedBox(height: height*.012,),
                TextFormField(
                  controller: _peopleTextEditingController,
                  decoration: myInputDecoration(labelText: ' تعداد افراد'),
                  style: myTextStyle(color: Color(0xFF212121)),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  // ignore: missing_return
                  validator: (String value){
                    if(value == null || value.isEmpty){
                      return ' تعداد افراد را وارد نمایید.';
                    }
                  }
                ),
                SizedBox(height: height*.012,),
                TextFormField(
                  controller: _degreeTextEditingController,
                  decoration: myInputDecoration(labelText: ' درجه میتر'),
                  style: myTextStyle(color: Color(0xFF212121)),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  // ignore: missing_return
                  validator: (String value){
                    if(value == null || value.isEmpty){
                      return ' تعداد افراد را وارد نمایید.';
                    }
                  }
                ),
                SizedBox(height: height*.012,),
                Container(
                  child: MyTextFieldDatePicker(
                  
                    labelText: "تاریخ",
                    prefixIcon: Icon(Icons.date_range),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    lastDate: DateTime.now().add(Duration(days: 366)),
                    firstDate: DateTime.now().subtract(Duration(days: 366)),
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    onDateChanged: (selectedDate) {
                      // Do something with the selected date
                      _mySelectedDate = selectedDate;
                    },
                  ),
                ),
                SizedBox(height: 15.0,),
                Container(
                  child: RaisedButton(
                    color: Color(0xFFFF5722),
                    child: Text('ثبت', style: myTextStyle(color: Colors.white),),
                    onPressed: (){ 
                      Map dataToSend = {
                        'water_id': _dropdownValue,
                        'neighbors_name' : _nameTextEditingController.text,
                        'people': _peopleTextEditingController.text,
                        'meter_degree': _degreeTextEditingController.text,
                        'date': _mySelectedDate != null ? _mySelectedDate.toString() : DateFormat('y-M-d').format(DateTime.now()).toString()  
                      };
                      addWaterNeighbor(_context, _neighnorScaffoldKey, dataToSend);
                    }
                  ),
                ),
              ],
            ),
          ), 
        ),
      ),
    );
  }
}