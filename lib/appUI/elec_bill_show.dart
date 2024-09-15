import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class Bills extends StatefulWidget {
  Bills({Key? key}) : super(key: key);

  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  late BuildContext _context;
  late Future<List<Map<String, dynamic>>> _fetchBill;
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
    _fetchBill = fetchBills();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

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
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchBill,
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                var data = snapshot.data!;
                return Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = data[index];
                      if (item['error'] != null && item['error'] == true) {
                        return showExceptionMsg(
                            context: _context, message: item['message']);
                      }
                      if (item['electricitybills'].isNotEmpty) {
                        var _bills = item['electricitybills'] as List<dynamic>;
                        List<Widget> _billWidget = [];

                        for (var i = 0; i < _bills.length; i++) {
                          var issueData = _bills[i]['issue_date'];
                          var dueDate = _bills[i]['due_date'];
                          issueData = DateFormat('y-d-M')
                              .format(DateTime.parse(issueData));
                          dueDate = DateFormat('y-d-M')
                              .format(DateTime.parse(dueDate));

                          _billWidget.add(
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 15.0, top: 10.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.cyan[50],
                                boxShadow: boxShadow(),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 15.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'میتر عمومی: ${item['consumer_name']} / ${item['no_of_submeters']}',
                                      style: myTextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text('دوره بل: ',
                                            style: myTextStyle(
                                                color: Color(0xff00BCD4),
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Container(
                                        child: Text(
                                            '${_bills[i]['meter_reading_turn']}',
                                            style: myTextStyle(
                                                color: Color(0xff00BCD4),
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      SizedBox(width: 15.0),
                                      Container(
                                        child: Text('مبلغ تادیه: ',
                                            style: myTextStyle(
                                                color: Color(0xff00BCD4),
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Container(
                                        child: Text(
                                            ' ${_bills[i]['bill_amount']}',
                                            style: myTextStyle(
                                                color: Color(0xff00BCD4),
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    padding:
                                        EdgeInsets.only(top: 8.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.cyan[100],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: Text('تاریخ صدور: ',
                                              style: myTextStyle(
                                                  color: Colors.grey[600]!,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        Container(
                                          child: Text(' $issueData',
                                              style: myTextStyle(
                                                  color: Colors.grey[600]!,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                        VerticalDivider(),
                                        Container(
                                          child: Text('تاریخ مهلت: ',
                                              style: myTextStyle(
                                                  color: Colors.grey[600]!,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        Container(
                                          child: Text(' $dueDate',
                                              style: myTextStyle(
                                                  color: Colors.grey[600]!,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                          var _subMetDegr =
                              _bills[i]['submeterdegrees'] as List<dynamic>;
                          for (var j = 0; j < _subMetDegr.length; j++) {
                            _billWidget.add(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    decoration: BoxDecoration(
                                      boxShadow: boxShadow(),
                                      color: Color(0xFFF0F0F0),
                                    ),
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                                '${_subMetDegr[j]['submeter']['submeter_consumer']}',
                                                style: myTextStyle(
                                                    color: Color(0xFF212121),
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 10.0, bottom: 20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.cyan[50],
                                                    boxShadow: boxShadow(),
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    50.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    50.0)),
                                                  ),
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('مبلغ تادیه',
                                                      style: myTextStyle(
                                                          color:
                                                              Color(0xff212121),
                                                          fontSize: 14)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(5.0),
                                                  constraints: BoxConstraints(
                                                      minWidth: 70.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFF5722),
                                                    boxShadow: boxShadow(),
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    50.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    50.0)),
                                                  ),
                                                  child: Text(
                                                    '${_subMetDegr[j]['bill_amount'].toInt()}',
                                                    style: myTextStyle(
                                                        fontSize: 18.0,
                                                        color:
                                                            Color(0xffffffff),
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Container(
                                        padding: EdgeInsets.only(
                                            left: 8.0,
                                            top: 8.0,
                                            right: 8.0,
                                            bottom: 15.0),
                                        child: Column(
                                          children: [
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                      child: Text(
                                                          'درجه حالیه:  ',
                                                          style:
                                                              myTextStyle())),
                                                  Container(
                                                    child: Text(
                                                        '${_subMetDegr[j]['current_degree']}'),
                                                  ),
                                                  Container(
                                                    height: 20.0,
                                                    child: VerticalDivider(
                                                        color: Colors.grey),
                                                  ),
                                                  Container(
                                                      child: Text(
                                                          'درجه مصرف شده:  ',
                                                          style:
                                                              myTextStyle())),
                                                  Container(
                                                    child: Text(
                                                        '${_subMetDegr[j]['consumed_degree']}'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                ],
                              ),
                            );
                          }

                          _billWidget
                              .add(Divider(thickness: 2, color: Colors.grey));
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _billWidget,
                        );
                      } else {
                        return showExceptionMsg(
                            context: _context,
                            message: 'بل پیدا نشد. هنوز بل ثبت نشد.');
                      }
                    },
                  ),
                );
              } else {
                return Center(child: Text('بل پیدا نشد.'));
              }
            },
          ),
        ),
      ),
    );
  }
}
