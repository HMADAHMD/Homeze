import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homeze_screens/resources/auth_methods.dart';
import 'package:homeze_screens/responsive/responsive_screen.dart';
import 'package:homeze_screens/screens/login_screen.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/utils/utils.dart';
import 'package:homeze_screens/widgets/small_widgets.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _numberController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _numberController.dispose();
  }

  validateForm() {
    if (_nameController.text.length < 3) {
      Fluttertoast.showToast(msg: 'Name must be atleast 4 characters');
    } else if (_passwordController.text.length < 6) {
      Fluttertoast.showToast(msg: 'Password must be atleast 6 characters long');
    } else if (_numberController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Phone number is required');
    } else if (!_emailController.text.contains('@')) {
      Fluttertoast.showToast(msg: 'Email address is not valid');
    } else {
      signUpUser();
      //savetaskerInfo();
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  saveUserInfo() async {
    final _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    String uid = user.uid;
    final fUser = uid;

    if (fUser != null) { 
      Map userMap = {
        "id": fUser,
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _numberController.text.trim(),
      };
      DatabaseReference taskerRef =
          FirebaseDatabase.instance.ref().child('users');
      taskerRef.child(fUser).set(userMap);
    } else {
      Fluttertoast.showToast(msg: 'Account has not been created');
    }
  }

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        fullname: _nameController.text,
        number: _numberController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      saveUserInfo();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ResponsiveScreen()));
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/Login.jpg",
                height: 250,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Welcome to HomeZe\n Registration",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  color: blueclr,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 65,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('assets/images/user_icon.png'),
                        ),
                  Positioned(
                      bottom: -8,
                      left: 85,
                      child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.grey,
                          )))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    MyTextfield(
                        hintText: 'Fullname',
                        keyboaredType: TextInputType.name,
                        mycontroller: _nameController,
                        correction: false),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextfield(
                        hintText: 'email',
                        keyboaredType: TextInputType.emailAddress,
                        mycontroller: _emailController,
                        correction: false),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextfield(
                        hintText: 'number',
                        keyboaredType: TextInputType.number,
                        mycontroller: _numberController,
                        correction: false),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextfield(
                      hintText: 'password',
                      keyboaredType: TextInputType.name,
                      mycontroller: _passwordController,
                      correction: false,
                      isPass: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 70,
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: blueclr,
                          )
                        : MyTextButtons(
                            name: 'SignUp',
                            myOnPressed: () {
                              validateForm();
                            }),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: blueclr),
                    ),
                    TextSpan(
                        text: 'Login',
                        style: TextStyle(color: orangeclr),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigateToLogin();
                          })
                  ]),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
