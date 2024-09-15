import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hesab_ketab/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/utils/database_activity.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmetersList extends StatefulWidget {
  const SubmetersList({Key? key}) : super(key: key);

  @override
  _SubmetersListState createState() => _SubmetersListState();
}

class _SubmetersListState extends State<SubmetersList> {
  final GlobalKey<ScaffoldState> _submeterListScaffoldStateKey =
      GlobalKey<ScaffoldState>();
  late Future<List<dynamic>> _futureSubmeter;
  final API_Config _apiConfig = API_Config();
  final DateFormat _dateFormat = DateFormat('y-d-M');
  late BuildContext _context;

  @override
  void initState() {
    super.initState();
    _futureSubmeter = fetchSubmeter();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _submeterListScaffoldStateKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('میترهای فرعی'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.01),
        child: FutureBuilder<List<dynamic>>(
          future: _futureSubmeter,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (data[index]['error'] == true) {
                    return showExceptionMsg(
                        context: _context, message: data[index]['message']);
                  }

                  if (data[index]['submeters'].isNotEmpty) {
                    List<TableRow> _tableRow = [
                      TableRow(
                        children: [
                          Text('نام میتر',
                              style: myTextStyle(fontWeight: FontWeight.w600)),
                          Text('درجه میتر',
                              style: myTextStyle(fontWeight: FontWeight.w600)),
                          Text('تاریخ ثبت',
                              style: myTextStyle(fontWeight: FontWeight.w600)),
                          Text('',
                              style: myTextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ];

                    for (var submeter in data[index]['submeters']) {
                      final formattedDate =
                          _dateFormat.format(DateTime.parse(submeter['date']));
                      _tableRow.add(
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('${submeter['submeter_consumer']}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('${submeter['meter_degree']}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(formattedDate),
                            ),
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.times),
                              color: Colors.red,
                              splashRadius: 15.0,
                              visualDensity:
                                  VisualDensity(vertical: -4, horizontal: 0),
                              iconSize: 16,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                myDelete(
                                    context: _context, meterID: submeter['id']);
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    return Material(
                      child: Column(
                        children: [
                          Ink(
                            width: width,
                            padding: EdgeInsets.all(height * 0.012),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              boxShadow: boxShadow(),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
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
                                        '${data[index]['consumer_name']} - ${data[index]['no_of_submeters']}',
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
                                          child: Text(
                                            'میترهای فرعی',
                                            style: myTextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
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
                          ),
                          const Divider(thickness: 3.0),
                          SizedBox(height: height * 0.012),
                        ],
                      ),
                    );
                  } else {
                    return Material(
                      child: Column(
                        children: [
                          Container(
                            width: width,
                            padding: EdgeInsets.all(height * 0.012),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              boxShadow: boxShadow(),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data[index]['consumer_name']} - ${data[index]['meter_no']}',
                                    style: myTextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Center(
                                    child: Text(
                                      'میتر فرعی ندارد',
                                      style: myTextStyle(
                                          color: const Color(0xFFFF5622)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(thickness: 3.0),
                          SizedBox(height: height * 0.012),
                        ],
                      ),
                    );
                  }
                },
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Future<void> deleteSubmeter(int meterID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _userData = prefs.getString('user');
    final String? _accessToken = prefs.getString('accessToken');

    if (_userData == null || _accessToken == null) {
      return;
    }

    final Map<String, String> _header = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": 'application/json',
      'Authorization': _accessToken,
    };

    final Map<String, String> _submeterData = {
      'user': _userData,
      'id': meterID.toString(),
    };

    final response = await http.post(
      Uri.parse(_apiConfig.apiUrl('deleteSubmeter')),
      body: _submeterData,
      headers: _header,
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      createSnackBar(data['message'], _context, _submeterListScaffoldStateKey,
          color: Colors.cyan);
    } else {
      String message = 'Unknown Error';
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        message = data['message'] ?? message;
      } catch (_) {}
      createSnackBar('Message: $message Status Code: ${response.statusCode}',
          _context, _submeterListScaffoldStateKey,
          color: Colors.red);
    }
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
                Text('میتر فرعی خذف شود؟',
                    style: myTextStyle(
                        color: Colors.red,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('خیر',
                          style: myTextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Text('بلی',
                          style: myTextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        await deleteSubmeter(meterID);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
