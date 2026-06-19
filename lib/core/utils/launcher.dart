import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in an external app (browser, dialer, mail client, maps).
/// No-op if nothing can handle it. Accepts `tel:`, `mailto:`, `https:`,
/// `geo:` and other schemes.
Future<void> launchExternal(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
