import 'package:flutter/material.dart';

import '../../model/tile.dart';
import '../../utils/firestore/authentications.dart';
import '../../utils/widget_utils.dart';
import '../start_up/account_delete_alert_dialog.dart';
import '../start_up/edit_account_widget.dart';
import '../start_up/login_page.dart';

class AboutAccountMenusPage extends StatefulWidget {
  const AboutAccountMenusPage({Key? key}) : super(key: key);

  @override
  State<AboutAccountMenusPage> createState() => _AboutAccountMenusPageState();
}

class _AboutAccountMenusPageState extends State<AboutAccountMenusPage> {
  late List<Tile> aboutAccountMenus;

  @override
  void initState() {
    super.initState();
    aboutAccountMenus = generateAboutAppMenus();
  }

  List<Tile> generateAboutAppMenus () {
    return [
      Tile(
        leading: const Icon(Icons.manage_accounts),
        title: const Text('アカウント編集'),
        onTap: () => handleAccountEditOnTap()
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

  void handleAccountEditOnTap() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0)
          )
        ),
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: const EditAccountWidget()
          );
        }
    );
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
      appBar: WidgetUtils.createAppBar(context, 'アカウントについて'),
      body: SafeArea(
        child: ListView.builder(
            itemCount: aboutAccountMenus.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: aboutAccountMenus[index].leading,
                    title: aboutAccountMenus[index].title,
                    trailing: const Icon(Icons.arrow_forward_ios),
                    iconColor: aboutAccountMenus[index].isErrorText ? Theme.of(context).errorColor : Colors.black87,
                    textColor: aboutAccountMenus[index].isErrorText ? Theme.of(context).errorColor : Colors.black87,
                    onTap: aboutAccountMenus[index].onTap,
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
