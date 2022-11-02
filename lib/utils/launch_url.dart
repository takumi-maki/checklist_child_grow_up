import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  Future contactForm() async {
    final Uri contactFormUrl = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSfEdKoJqizieOq1IHkWpi99DamiyPzxMikN2_dxoh0T4UPNsA/viewform');
    if(!await launchUrl(contactFormUrl)) {
      throw 'Could not launch $contactFormUrl';
    }
  }
  Future privacyPolicy() async {
    final Uri privacyPolicyUrl = Uri.parse('https://checklist-child-grow-up.web.app/privacy_policy.html');
    if(!await launchUrl(privacyPolicyUrl)) {
      throw 'Could not launch $privacyPolicyUrl';
    }
  }
  Future termsOfService() async {
    final Uri termsOfServiceUrl = Uri.parse('https://checklist-child-grow-up.web.app/terms_of_service.html');
    if(!await launchUrl(termsOfServiceUrl)) {
      throw 'Could not launch $termsOfServiceUrl';
    }
  }
}