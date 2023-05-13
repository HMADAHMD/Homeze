import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeze_screens/responsive/mobile_screen.dart';
import 'package:homeze_screens/screens/post_job.dart';
import 'package:homeze_screens/screens/service_screen.dart';
import 'package:homeze_screens/utils/bottom_tabs.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/provider/user_provider.dart';


class MyTextfield extends StatelessWidget {
  final String hintText;
  final TextInputType keyboaredType;
  final bool isPass;
  final TextEditingController mycontroller;
  final bool correction;

  const MyTextfield(
      {required this.hintText,
      required this.keyboaredType,
      this.isPass = false,
      required this.mycontroller,
      required this.correction});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: blueclr)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: blueclr)),
          errorBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: blueclr)),
          hintStyle: TextStyle(color: Colors.grey),
          hintText: hintText),
      keyboardType: keyboaredType,
      obscureText: isPass,
      controller: mycontroller,
      autocorrect: correction,
      cursorColor: blueclr,
    );
  }
}

class MyTextButtons extends StatelessWidget {
  final myOnPressed;
  String name;
  MyTextButtons({required this.name, required this.myOnPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: myOnPressed,
      style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: Ink(
          decoration: BoxDecoration(
              color: orangeclr, borderRadius: BorderRadius.circular(50)),
          child: Container(
            width: 400,
            height: 50,
            alignment: Alignment.center,
            child: Center(
              child: Text(
                name,
                style: GoogleFonts.poppins(
                    fontSize: 30, color: blueclr, fontWeight: FontWeight.w500),
              ),
            ),
          )),
    );
  }
}

class HomeService extends StatelessWidget {
  HomeService({required this.serviceName, required this.serviceImage});
  final String serviceName;
  final String serviceImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PostJob()));
      },
      child: Container(
        //margin: EdgeInsets.only(right: 5),
        padding: EdgeInsets.all(10.0),
        height: 120,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(
            color: Colors.blue.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(serviceImage, height: 45),
              const SizedBox(
                height: 20,
              ),
              Text(
                serviceName,
                style: TextStyle(fontSize: 15),
              )
            ]),
      ),
    );
  }
}

class Services extends StatelessWidget {
  Services({required this.serviceName, required this.serviceImage});
  final String serviceName;
  final String serviceImage;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PostJob()));
      },
      child: Container(
        //margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.all(20.0),
        height: 140,
        width: 110,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(
            color: Colors.blue.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(serviceImage, height: 40),
              const SizedBox(
                height: 10,
              ),
              Text(
                serviceName,
                style: TextStyle(fontSize: 15),
              )
            ]),
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  final String listName;
  Icon listIcon;
  ListItems({required this.listName, required this.listIcon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: listIcon,
        iconColor: blueclr,
        title: Text(listName),
        tileColor: grayclr,
        trailing: Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}

class Categories extends StatelessWidget {
  Categories({
    required this.type,
    required this.isCheck,
  });
  final String type;
  final bool isCheck;
  void myFunction() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(children: [
              Text(
                type,
                style: TextStyle(
                    color: blueclr, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Spacer(),
              isCheck
                  ? TextButton(
                      onPressed: () {},
                      child: const Text(
                        'View all',
                        style: TextStyle(color: blueclr),
                      ))
                  : Container()
            ]),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                HomeService(serviceName: 'Cleaning', serviceImage: cleaning),
                const SizedBox(
                  width: 10,
                ),
                HomeService(serviceName: 'Plumber', serviceImage: plumber),
                const SizedBox(
                  width: 10,
                ),
                HomeService(
                    serviceName: 'Electrician', serviceImage: electrician),
                const SizedBox(
                  width: 10,
                ),
                HomeService(serviceName: 'Carpenter', serviceImage: carpenter),
                const SizedBox(
                  width: 10,
                ),
                HomeService(serviceName: 'Painter', serviceImage: painter),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class DateTimePickerExample extends StatelessWidget {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date and Time Picker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Select a date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  _dateController.text = selectedDate.toString();
                }
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Time',
                hintText: 'Select a time',
                suffixIcon: Icon(Icons.access_time),
              ),
              onTap: () async {
                final TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  _timeController.text = selectedTime.format(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
