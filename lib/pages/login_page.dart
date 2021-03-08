import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:qyuclient/classes/Api.dart' as api;

import '../classes/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LogInPage extends StatefulWidget  {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  //Controllers for e-mail and password textfields.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();
  final TextEditingController smscode = TextEditingController();

  //Handling signup and signin
  bool signUp = true;
  bool visible = false;
  PhoneNumber number = PhoneNumber(isoCode: 'UK');
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    //final SmsAutoFill _autoFill = SmsAutoFill();
    //_autoFill.hint.then((value) {
     // print(value);
    //});

   // waitDialog(context, duration: Duration(seconds: 3));
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset:true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            //e-mail textfield
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
              ),
            ),

            //password textfield
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
              ),
            ),

            //Sign in / Sign up button
            RaisedButton(
              onPressed: () {
                if (signUp) {
                  //Provider sign up method
                  context.read<AuthenticationProvider>().signUp(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                } else {
                  //Provider sign in method
                  context.read<AuthenticationProvider>().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                }
              },
              child: signUp ? Text("Sign Up") : Text("Sign In"),
            ),

            //Sign up / Sign In toggler
            OutlineButton(
              onPressed: () {
                setState(() {
                  signUp = !signUp;
                });
              },
              child: signUp ? Text("Have an account? Sign In") : Text("Create an account"),
            )
            ,
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: EdgeInsets.only(bottom: 5,top:5,left:20,right:20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors:[Color.fromRGBO(167, 135, 243, 1),Color.fromRGBO(209, 145, 238, 1)],
                      
                    )
                ),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber);
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: TextStyle(color: Colors.white),
                  textStyle: TextStyle(color:  Colors.white),
                  initialValue: number,
                  textFieldController: phonenumber,

                  formatInput: false,
                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                  inputBorder: InputBorder.none,
                  onSaved: (PhoneNumber number) {
                    print('On Saved: $number');
                  },
                ),
              ),
            ),
            //password textfield
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: phonenumber,
                decoration: InputDecoration(
                  labelText: "phone number",
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  visible = true;
                });
              //  context.read<AuthenticationProvider>().signUpwithphone(context,phonenumber.text.trim());
              },
              child: Text("Send Codes"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: smscode,
                decoration: InputDecoration(
                  labelText: "codes",
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            RaisedButton(
              onPressed: () {

                context.read<AuthenticationProvider>().signInwithVerificationId(smscode.text.trim());
              },
              child: Text("Verify phone"),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: visible,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );

  }
}