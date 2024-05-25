import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_verification/home.dart';
import 'package:pinput/pinput.dart';

// ignore: must_be_immutable
class ScreenOtp extends StatefulWidget {
  String number;
  String otp;
  ScreenOtp({super.key, required this.number, required this.otp});

  @override
  State<ScreenOtp> createState() => _ScreenOtpState();
}

class _ScreenOtpState extends State<ScreenOtp> {
  String? code;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                    width: 300,
                    height: 300,
                    child:
                        Lottie.asset('assets/lottie/otp.json', repeat: false)),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'OTP Verification',
                  style: GoogleFonts.anton(color: Colors.black, fontSize: 22),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'We\'ve Sent an OTP to mobile number ${widget.number}! Enter the \n one-time passcode to proceed with login.',
                  style: GoogleFonts.kalam(color: Colors.black, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Pinput(
                  length: 6,
                  errorPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                          ))),
                  defaultPinTheme: PinTheme(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                          ))),
                  onChanged: (value) {
                    code = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => verifyOtp(),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        'Verify',
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

  void verifyOtp() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.otp, smsCode: code!);

    try {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (ctx) => const ScreenHome()));
    } catch (e) {
      log(e.toString());
    }
  }
}
