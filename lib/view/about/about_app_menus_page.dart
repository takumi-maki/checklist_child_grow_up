import 'package:checklist_child_grow_up/view/start_up/account_delete_alert_dialog.dart';
import 'package:flutter/material.dart';

import '../../model/tile.dart';
import '../../utils/firestore/authentications.dart';
import '../../utils/launch_url.dart';
import '../../utils/widget_utils.dart';
import '../start_up/login_page.dart';

class AboutAppMenusPage extends StatefulWidget {
  const AboutAppMenusPage({Key? key}) : super(key: key);

  @override
  State<AboutAppMenusPage> createState() => _AboutAppMenusPageState();
}

class _AboutAppMenusPageState extends State<AboutAppMenusPage> {
  late List<Tile> aboutAppMenus;

  @override
  void initState() {
    super.initState();
    aboutAppMenus = generateAboutAppMenus();
  }

  List<Tile> generateAboutAppMenus () {
    final launchUrl = LaunchUrl();
    return [
      Tile(
        leading: const Icon(Icons.security),
        title: const Text('プライバシーポリシー'),
        onTap: () => launchUrl.privacyPolicy()
      ),
      Tile(
        leading: const Icon(Icons.description),
        title: const Text('利用規約'),
        onTap: () => launchUrl.termsOfService()
      ),
      Tile(
        leading: const Icon(Icons.contact_mail),
        title: const Text('お問い合わせ'),
        onTap: () => launchUrl.contactForm()
      ),
      Tile(
        leading: const Icon(Icons.logout),
        title: const Text('ログアウト'),
        onTap: () => handleSignOutOnTap()
      ),
      Tile(
        leading: const Icon(Icons.delete),
        title: const Text('アカウント削除'),
        isErrorText: true,
        onTap: () => handleAccountDeleteOnTap(),
      ),
    ];
  }

  void handleSignOutOnTap() {
    AuthenticationFirestore.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
        return const LoginPage();
      }), (_) => false
    );
  }

  void handleAccountDeleteOnTap() {
    showDialog(context: context, barrierDismissible: false, builder: (context) {
      return const AccountDeleteAlertDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar(context, 'アプリについて'),
      body: ListView.builder(
        itemCount: aboutAppMenus.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: aboutAppMenus[index].leading,
                title: aboutAppMenus[index].title,
                trailing: const Icon(Icons.arrow_forward_ios),
                iconColor: aboutAppMenus[index].isErrorText ? Theme.of(context).errorColor : Colors.black87,
                textColor: aboutAppMenus[index].isErrorText ? Theme.of(context).errorColor : Colors.black87,
                onTap: aboutAppMenus[index].onTap,
              ),
            ),
          );
        }
      ),
    );
  }
}
