import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hesab_ketab/appUI/add_electricity_bill.dart';
import 'package:hesab_ketab/appUI/add_submeters.dart';
import 'package:hesab_ketab/appUI/elec_bill_show.dart';
import 'package:hesab_ketab/appUI/elec_submeters_list.dart';
import 'package:hesab_ketab/appUI/elect_mainmeter_list.dart';
import 'package:hesab_ketab/myWidgets/cost_widgets.dart';
import 'package:hesab_ketab/appUI/add_electricity_info.dart';

class Electricity extends StatefulWidget {
  const Electricity({Key? key}) : super(key: key);

  @override
  _ElectricityState createState() => _ElectricityState();
}

class _ElectricityState extends State<Electricity> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final _paddings = EdgeInsets.all(height * 0.015);

    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          SizedBox(height: 10.0),
          buildCard(
            context,
            'ثبت میترهای عمومی',
            AddMainMeter(),
            MainMeterList(),
          ),
          Divider(thickness: 3.0, height: 20.0),
          SizedBox(height: 10.0),
          buildCard(
            context,
            'ثبت میترهای فرعی',
            AddSubmeters(),
            SubmetersList(),
          ),
          Divider(thickness: 3.0, height: 20.0),
          SizedBox(height: height * 0.012),
          buildBillCard(context),
          Divider(thickness: 3.0, height: 20.0),
        ],
      ),
    );
  }

  Widget buildCard(
      BuildContext context, String title, Widget addPage, Widget listPage) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
      decoration: BoxDecoration(
        boxShadow: boxShadow(),
        color: Color(0xFFF0F0F0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: iconButtonBackground(
                    color: Color(0x23FF5722), radius: 50.0),
                child: IconButton(
                  visualDensity: VisualDensity(vertical: 4, horizontal: 4),
                  color: Color(0xFFFF5722),
                  tooltip: 'ثبت $title',
                  icon: Icon(FontAwesomeIcons.plus, size: 27.0),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => addPage)),
                ),
              ),
              Text(title,
                  style: myTextStyle(color: Colors.black, fontSize: 17.0)),
              Container(
                height: MediaQuery.of(context).size.height * 0.04,
                decoration: iconButtonBackground(
                    color: Color(0x2300bcd4), radius: 10.0),
                child: IconButton(
                  padding: EdgeInsets.all(0.0),
                  visualDensity: VisualDensity(vertical: 0, horizontal: 4),
                  color: Color(0xff00BCD4),
                  tooltip: 'مشاهده $title',
                  icon: Icon(FontAwesomeIcons.ellipsisH, size: 24.0),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => listPage)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBillCard(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(height * 0.015),
      decoration: BoxDecoration(
        boxShadow: boxShadow(),
        color: Color(0xFFF0F0F0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ثبت بل و درجه حالیه میترهای فرعی',
                  style: myTextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: height * 0.024),
              Container(
                decoration: iconButtonBackground(
                    color: Color(0x23FF5722), radius: 50.0),
                child: IconButton(
                  padding: EdgeInsets.all(15.0),
                  visualDensity: VisualDensity(horizontal: 4, vertical: 4),
                  iconSize: 50.0,
                  icon: Icon(FontAwesomeIcons.plus, color: Color(0xFFFF5722)),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddElectricityBill())),
                ),
              ),
              SizedBox(height: height * 0.018),
              Container(
                height: 25,
                width: 60,
                decoration: iconButtonBackground(
                    color: Color(0x2300BCD4), radius: 10.0),
                child: IconButton(
                  padding: EdgeInsets.all(0.0),
                  visualDensity: VisualDensity(horizontal: 0, vertical: 4),
                  iconSize: 24,
                  icon: Icon(FontAwesomeIcons.ellipsisH,
                      color: Color(0xff00BCD4)),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Bills())),
                ),
              ),
              SizedBox(height: height * 0.018),
            ],
          ),
        ),
      ),
    );
  }
}
