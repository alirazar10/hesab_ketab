import 'package:flutter/material.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class WaterBills extends StatefulWidget {
  WaterBills({Key? key}) : super(key: key);

  @override
  _WaterBillsState createState() => _WaterBillsState();
}

class _WaterBillsState extends State<WaterBills> {
  final GlobalKey<ScaffoldState> _waterBillScaffoldKey =
      GlobalKey<ScaffoldState>();
  late BuildContext _context;
  late Future futureWaterBill;
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
    futureWaterBill = fetchWaterBill();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _waterBillScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xC2212121),
        centerTitle: true,
        title: const Text('بل‌های آب'),
      ),
      body: Material(
        child: Container(
          child: FutureBuilder(
            future: futureWaterBill,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return Container(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (data[index]['error'] != null &&
                          data[index]['error'] == true) {
                        return showExceptionMsg(
                            context: _context, message: data[index]['message']);
                      }

                      List<Widget> _billListWidget = [];
                      if (data[index]['waterbills'].isNotEmpty) {
                        var _billData = data[index]['waterbills'];
                        for (var i = 0; i < _billData.length; i++) {
                          var issueDate = _billData[i]['issue_date'];
                          var dueDate = _billData[i]['due_date'];
                          issueDate = issueDate != null
                              ? DateFormat('y-d-M')
                                  .format(DateTime.parse(issueDate))
                              : '';
                          dueDate = dueDate != null
                              ? DateFormat('y-d-M')
                                  .format(DateTime.parse(dueDate))
                              : '';

                          _billListWidget.add(
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(
                                  bottom: 15.0, top: 10.0),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.cyan[50],
                                boxShadow: boxShadow(),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'میتر عمومی: ${data[index]['consumer_name'] + ' / ' + data[index]['subscription_no'].toString()}',
                                      style: myTextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          'دوره بل: ',
                                          style: myTextStyle(
                                              color: const Color(0xff00BCD4),
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '${_billData[i]['meter_reading_turn']}',
                                          style: myTextStyle(
                                              color: const Color(0xff00BCD4),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const SizedBox(width: 15.0),
                                      Container(
                                        child: Text(
                                          'مبلغ تادیه: ',
                                          style: myTextStyle(
                                              color: const Color(0xff00BCD4),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        child: _billData[i]['bill_amount'] !=
                                                null
                                            ? Text(
                                                ' ${_billData[i]['bill_amount']}',
                                                style: myTextStyle(
                                                    color:
                                                        const Color(0xff00BCD4),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : const Text(''),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.cyan[100],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: Text(
                                            'تاریخ صدور: ',
                                            style: myTextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            ' $issueDate',
                                            style: myTextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const VerticalDivider(),
                                        Container(
                                          child: Text(
                                            'تاریخ مهلت: ',
                                            style: myTextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            ' $dueDate',
                                            style: myTextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                          var _neighbor = _billData[i]['neighbor_bills'];
                          for (var j = 0; j < _neighbor.length; j++) {
                            _billListWidget.add(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    decoration: BoxDecoration(
                                      boxShadow: boxShadow(),
                                      color: const Color(0xFFF0F0F0),
                                    ),
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              '${_neighbor[j]['waterneighbor']['neighbors_name']}',
                                              style: myTextStyle(
                                                  color:
                                                      const Color(0xFF212121),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 10.0, bottom: 20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.cyan[50],
                                                    boxShadow: boxShadow(),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(50.0),
                                                      topRight:
                                                          Radius.circular(50.0),
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('مبلغ تادیه',
                                                      style: myTextStyle(
                                                          color:
                                                              Color(0xff212121),
                                                          fontSize: 14)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 70.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFF5722),
                                                    boxShadow: boxShadow(),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(50.0),
                                                      topLeft:
                                                          Radius.circular(50.0),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '${_neighbor[j]['bill_amount'].toInt()}',
                                                    style: myTextStyle(
                                                        fontSize: 18.0,
                                                        color: const Color(
                                                            0xffffffff),
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
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            top: 8.0,
                                            right: 8.0,
                                            bottom: 15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    child: Text(
                                                        'تعداد افراد:  ',
                                                        style: myTextStyle())),
                                                Container(
                                                  child: Text(
                                                      '${_neighbor[j]['people']}'),
                                                ),
                                                Container(
                                                    height: 20.0,
                                                    child:
                                                        const VerticalDivider(
                                                            color:
                                                                Colors.grey)),
                                                Container(
                                                    child: Text(
                                                        'درجه مصرف شده:  ',
                                                        style: myTextStyle())),
                                                Container(
                                                  child: Text(
                                                      '${_billData[i]['consumed_degree']}'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                ],
                              ),
                            );
                          }
                        }
                      } else {
                        return showExceptionMsg(
                            context: _context,
                            message: 'بل پیدا نشد. هنوز بل ثبت نشد.');
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
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
