import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';

class WaterNeighborList extends StatefulWidget {
  WaterNeighborList({Key? key}) : super(key: key);

  @override
  _WaterNeighborListState createState() => _WaterNeighborListState();
}

class _WaterNeighborListState extends State<WaterNeighborList> {
  late BuildContext _context;
  final GlobalKey<ScaffoldState> _neighborListScaffoldKey =
      GlobalKey<ScaffoldState>();
  late Future _futureNeighbor;
  late double height;
  late double width;
  late double bottomInset;

  @override
  void initState() {
    super.initState();
    _futureNeighbor = fetchWaterNeighbor();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    bottomInset = MediaQuery.of(context).viewInsets.bottom;
    var _padding = EdgeInsets.only(
      top: height * 0.012,
      bottom: bottomInset,
    );
    return Scaffold(
      key: _neighborListScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xC2212121),
        centerTitle: true,
        title: const Text('همسایه‌های شریک در آب'),
      ),
      body: Container(
        padding: _padding,
        child: FutureBuilder(
          future: _futureNeighbor,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (data[index]['error'] != null &&
                      data[index]['error'] == true) {
                    return showExceptionMsg(
                        context: _context, message: data[index]['message']);
                  }

                  var neighbors = data[index]['waterneighbors'];
                  List<TableRow> _tableRow = [];
                  _tableRow.add(TableRow(
                    children: [
                      Text('نام میتر',
                          style: myTextStyle(fontWeight: FontWeight.w600)),
                      Text('تعداد افراد',
                          style: myTextStyle(fontWeight: FontWeight.w600)),
                      Text('درجه میتر',
                          style: myTextStyle(fontWeight: FontWeight.w600)),
                      Text('تاریخ ثبت',
                          style: myTextStyle(fontWeight: FontWeight.w600)),
                      Text('', style: myTextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ));

                  for (var i = 0; i < neighbors.length; i++) {
                    _tableRow.add(TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('${neighbors[i]['neighbors_name']}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('${neighbors[i]['people']}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('${neighbors[i]['meter_degree']}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                              '${DateFormat('y-M-d').format(DateTime.parse(neighbors[i]['date']))}'),
                        ),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.times),
                          color: Colors.red,
                          splashRadius: 15.0,
                          visualDensity:
                              const VisualDensity(vertical: -4, horizontal: 0),
                          iconSize: 16,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            myDelete(
                                context: _context, meterID: neighbors[i]['id']);
                          },
                        ),
                      ],
                    ));
                  }
                  return Column(
                    children: [
                      Container(
                        width: width,
                        padding: EdgeInsets.all(height * 0.012),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          boxShadow: boxShadow(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'میتر عمومی: ',
                                  style: myTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '${data[index]['consumer_name']} - ${data[index]['subscription_no']}',
                                  style: myTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: width,
                                    color: Colors.grey[300],
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('مصرف کننده‌ها',
                                        style: myTextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Table(
                                    children: _tableRow,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: 2.0),
                      SizedBox(height: height * 0.012),
                    ],
                  );
                },
              );
            }
            return const Center(child: RefreshProgressIndicator());
          },
        ),
      ),
    );
  }

  void myDelete({required BuildContext context, required int meterID}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.all(20),
          elevation: 10.0,
          titleTextStyle: myTextStyle(
              color: Colors.red, fontSize: 24.0, fontWeight: FontWeight.bold),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(FontAwesomeIcons.triangleExclamation,
                    size: 70, color: Colors.amberAccent),
                const SizedBox(height: 20.0),
                Text('میتر عمومی حذف شود؟',
                    style: myTextStyle(
                        color: Colors.red,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.red),
                      ),
                      child: Text('حذف',
                          style:
                              myTextStyle(color: Colors.white, fontSize: 16.0)),
                      onPressed: () {
                        setState(() {
                          deleteWaterNeighbor(
                              _context, _neighborListScaffoldKey, meterID);
                          _futureNeighbor = fetchWaterNeighbor();
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xff00BCD4)),
                      ),
                      child: Text('لغو',
                          style:
                              myTextStyle(color: Colors.white, fontSize: 16.0)),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
