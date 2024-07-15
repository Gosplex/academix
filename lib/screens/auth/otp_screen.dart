import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../helpers/helper_class.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/keyboard/custome_keyboard.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  final String verificationId;
  final String phoneNumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  final FocusNode _focusNode = AlwaysDisabledFocusNode();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('RESEND OTP',
                  style: Constants.body.copyWith(
                    color: Constants.primaryColor.withOpacity(0.8),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Enter Verification Code',
                  style: Constants.heading1,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Lottie.network(
                  'https://lottie.host/aa75004a-68fc-404d-9509-948eb736d378/1K3W9dtRTg.json',
                  repeat: false,
                  height: 200,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                'Enter OTP',
                style: Constants.heading2,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                'Enter the 6-digit code sent to you at (${widget.phoneNumber})',
                style: Constants.body.copyWith(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Pinput(
              length: 6,
              focusNode: _focusNode,
              showCursor: true,
              controller: otpController,
              closeKeyboardWhenCompleted: true,
              defaultPinTheme: PinTheme(
                width: 58,
                height: 60, // 55
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Constants.primaryColor,
                    width: 2,
                  ),
                ),
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              onCompleted: (value) {
                ap.verifyOTP(value, widget.verificationId, context);
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const CircularProgressIndicator(
                        color: Constants.primaryColor,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                    width: double.infinity,
                    // height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      onPressed: () {
                        ap.verifyOTP(
                            otpController.text, widget.verificationId, context);
                      },
                      child: Text(
                        'Verify OTP',
                        style: Constants.body.copyWith(
                          color: Constants.white,
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: CustomKeyboard(
                controller: otpController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
