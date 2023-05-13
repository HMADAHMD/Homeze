import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeze_screens/screens/map_screen.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/widgets/small_widgets.dart';

class CreateTask extends StatefulWidget {
  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _infoController = TextEditingController();
  final _priceController = TextEditingController();
  String _taskPrice = '0';

  myAlertView() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add price'),
          content: TextField(
            controller: _priceController,
            autocorrect: false,
            keyboardType: TextInputType.number,
            cursorColor: orangeclr,
            decoration: InputDecoration(
                fillColor: grayclr,
                filled: true,
                enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: darkgray)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: orangeclr)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: orangeclr))),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform some action
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _taskPrice = _priceController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Done',
                style: TextStyle(color: blueclr),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: skyclr,
        title: const Text(
          'Create a Task',
          style: TextStyle(
              color: blueclr, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provide Instructions about task',
              style: GoogleFonts.poppins(
                  fontSize: 25, fontWeight: FontWeight.w600, color: blueclr),
            ),
            const SizedBox(
              height: 10,
            ),
            Categories(type: 'Select Type of work', isCheck: false),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Give some brief instructions',
              style: GoogleFonts.poppins(
                  fontSize: 25, fontWeight: FontWeight.w600, color: blueclr),
            ),
            Container(
                height: 160,
                child: TextField(
                  controller: _infoController,
                  autocorrect: false,
                  cursorColor: orangeclr,
                  maxLines: 6,
                  decoration: InputDecoration(
                      fillColor: grayclr,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkgray),
                          borderRadius: BorderRadius.circular(10)),
                      errorBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      hintText: 'Give some brief about work...'),
                )),
            Container(
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: skyclr),
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/upload.png',
                        height: 70,
                      ),
                      Text(
                        'upload image',
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: darkgray,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Add Your Price: ',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      )),
                  Spacer(),
                  GestureDetector(
                    onTap: myAlertView,
                    child: Container(
                        decoration: BoxDecoration(
                            color: darkgray,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Rs. ${_taskPrice}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        )),
                  )
                ],
              ),
            ),
            MyTextButtons(
                name: 'Search',
                myOnPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapScreen()));
                })
          ],
        ),
      ),
    );
  }
}
