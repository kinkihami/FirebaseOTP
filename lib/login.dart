import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_verification/otp.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController _mobileNumber = TextEditingController();
  String otp = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Lottie.asset('assets/lottie/login.json',
                      fit: BoxFit.fill),
                ),
                Text(
                  'Login',
                  style: GoogleFonts.anton(color: Colors.black, fontSize: 22),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome! Enter your phone number below. We'll send you\na login one-time passcode (OTP).",
                  style: GoogleFonts.kalam(color: Colors.black54, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _mobileNumber,
                    style: GoogleFonts.lora(color: Colors.black, fontSize: 12),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        hintText: 'Phone Number',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => otpsent(),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        'Send OTP',
                        style: GoogleFonts.anton(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void otpsent() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + _mobileNumber.text,
      verificationCompleted: (phoneAuthCredential) async {},
      verificationFailed: (error) {
        log(error.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message.toString())));
      },
      codeSent: (verificationId, forceResendingToken) {
        otp = verificationId;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ScreenOtp(
                      number: _mobileNumber.text,
                      otp: otp,
                    )));
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }
}
