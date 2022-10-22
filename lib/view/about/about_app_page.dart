
import 'package:checklist_child_grow_up/model/tile.dart';
import 'package:flutter/material.dart';

import '../../utils/firestore/authentications.dart';
import '../../utils/function_utils.dart';
import '../../utils/widget_utils.dart';
import '../start_up/login_page.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  @override
  Widget build(BuildContext context) {
    List<Tile> aboutAppContentList = [
      Tile(
        leading: const Icon(Icons.security),
        title: const Text('プライバシーポリシー'),
        onTap: () {
          FunctionUtils.privacyPolicyLaunchUrl();
        }
      ),
      Tile(
        leading: const Icon(Icons.description),
        title: const Text('利用規約'),
        onTap: () {
          FunctionUtils.termsOfServiceLaunchUrl();
        }
      ),
      Tile(
        leading: const Icon(Icons.contact_mail),
        title: const Text('お問い合わせ'),
        onTap: () {
          FunctionUtils.contactFormLaunchUrl();
        }
      ),
      Tile(
        leading: const Icon(Icons.logout),
        title: const Text('ログアウト'),
        onTap: () {
          AuthenticationFirestore.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return const LoginPage();
          }));
        }
      ),
    ];
    return Scaffold(
      appBar: WidgetUtils.createAppBar('アプリについて'),
      body: ListView.builder(
        itemCount: aboutAppContentList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: aboutAppContentList[index].leading,
                title: aboutAppContentList[index].title,
                trailing: const Icon(Icons.arrow_forward_ios),
                textColor: Colors.black87,
                iconColor: Colors.black87,
                onTap: aboutAppContentList[index].onTap,
              ),
            ),
          );
        }
      ),
    );
  }
}
