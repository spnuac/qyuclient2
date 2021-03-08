import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthenticationProvider {
  final FirebaseAuth firebaseAuth;
  User user;
  String verifationid='';
  //FirebaseAuth instance
  AuthenticationProvider(this.firebaseAuth);
  //Constuctor to initalize the FirebaseAuth instance

  //Using Stream to listen to Authentication State
  Stream<User> get authState => firebaseAuth.idTokenChanges();


  //............RUDIMENTARY METHODS FOR AUTHENTICATION................
  Future<User> signInWithEmailLink(String email,String link) async{
        return (await firebaseAuth.signInWithEmailLink(
        email: email,
        emailLink:link.toString()
        )).user;
  }
  Future<dynamic> signInWithEmailAndLink(String _userEmail) async {
    try {
      return await firebaseAuth.sendSignInLinkToEmail(
          email: _userEmail,
          actionCodeSettings: ActionCodeSettings(
            url: 'https://grub24.page.link/',
            handleCodeInApp: true,
            //iOSBundleID: 'com.google.firebase.flutterauth',
            androidPackageName: 'app.qyu.grub',
            //androidInstallIfNotAvailable: true,
          )
      );
    }
    catch(e){
      print(e);
      return false;
    }
  }

  //SIGN UP METHOD
  Future<dynamic> signUp({String email, String password}) async {
    try {
    final new_user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
          return this.signIn(email: email,password: password);
    }  catch (e) {
      if(e.code.toLowerCase() == 'email-already-in-use') {
        return this.signIn(email: email,password: password);
      }
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future<dynamic> sendforgetpass(email) async {
    try {
       await firebaseAuth.sendPasswordResetEmail(email: email);
       return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  //SIGN IN METHOD
  Future<dynamic> signIn({String email, String password}) async {
    try {
      final new_user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if(new_user!=null && new_user.user.emailVerified)
        return true;
      else if(new_user!=null){
          new_user.user.sendEmailVerification();
        return "One email sent to you , please click on verify email link and try again ...";
      }
      else
          return "Can not login with this email address";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

    void signUpwithphone(context,_phoneNumber,void errormanage(String msg),void codeSent(String v),void errorTimeout(String v) ) async{
    try{

      await FirebaseAuth.instance.verifyPhoneNumber (
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('verificationCompleted');
          await this.firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number')
            errormanage("The provided phone number is not valid.");
          else
            errormanage(e.message);
        },

        codeSent: (String verificationId, int resendToken) async {
          this.verifationid = verificationId;
          //print('sms sent , hala promt bayad neshun bede o vared kone');
          codeSent(verificationId);
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          //print('codeAutoRetrievalTimeout');
          errorTimeout(verificationId);
          // Auto-resolution timed out...
        },
      );
    }
    catch(e){
print(e);
    }
  }
  void signInwithVerificationId(code, {void afterLogin(String uid), void failedLogin(String msg)}) async{
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: this.verifationid,
        smsCode: code,
      );
      this.user = (await firebaseAuth.signInWithCredential(credential)).user;
      if(afterLogin!=null)
        afterLogin(this.user.uid);
    } catch (e) {
      if(failedLogin!=null)
        failedLogin(e.toString());
    }
  }
  //SIGN OUT METHOD
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}