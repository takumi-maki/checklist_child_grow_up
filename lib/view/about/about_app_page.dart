import 'package:checklist_child_grow_up/view/start_up/account_delete_alert_dialog.dart';
import 'package:flutter/material.dart';

import '../../model/tile.dart';
import '../../utils/firestore/authentications.dart';
import '../../utils/launch_url.dart';
import '../../utils/widget_utils.dart';
import '../start_up/login_page.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  late List<Tile> aboutAppContentList;

  @override
  void initState() {
    super.initState();
    final launchUrl = LaunchUrl();
    aboutAppContentList = [
      Tile(
          leading: const Icon(Icons.security),
          title: const Text('プライバシーポリシー'),
          onTap: () {
            launchUrl.privacyPolicy();
          }
      ),
      Tile(
          leading: const Icon(Icons.description),
          title: const Text('利用規約'),
          onTap: () {
            launchUrl.termsOfService();
          }
      ),
      Tile(
          leading: const Icon(Icons.contact_mail),
          title: const Text('お問い合わせ'),
          onTap: () {
            launchUrl.contactForm();
          }
      ),
      Tile(
          leading: const Icon(Icons.logout),
          title: const Text('ログアウト'),
          onTap: () {
            AuthenticationFirestore.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }),
                    (_) => false
            );
          }
      ),
      Tile(
        id: 'deleteAccount',
        leading: const Icon(Icons.delete),
        title: const Text('アカウント削除'),
        onTap: () => showAccountDeleteAlertDialog()
      ),
    ];
  }

  void showAccountDeleteAlertDialog() {
    showDialog(context: context, barrierDismissible: false, builder: (context) {
      return const AccountDeleteAlertDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar(context, 'アプリについて'),
      body: ListView.builder(
        itemCount: aboutAppContentList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: aboutAppContentList[index].leading,
                title: aboutAppContentList[index].title,
                trailing: const Icon(Icons.arrow_forward_ios),
                iconColor: aboutAppContentList[index].id == 'deleteAccount' ? Colors.red : Colors.black87,
                textColor: aboutAppContentList[index].id == 'deleteAccount' ? Colors.red : Colors.black87,
                onTap: aboutAppContentList[index].onTap,
              ),
            ),
          );
        }
      ),
    );
  }
}
