import 'package:smart_kishan/features/auth/data/otp_purpose.dart';

class OtpFlowArgs {
  const OtpFlowArgs({required this.phone, required this.purpose});
  final String phone;
  final OtpPurpose purpose;
}

class VerifiedFlowArgs {
  const VerifiedFlowArgs({
    required this.phone,
    required this.verificationToken,
  });
  final String phone;
  final String verificationToken;
}
