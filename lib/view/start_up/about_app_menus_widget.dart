import 'package:flutter/material.dart';

import '../../model/tile.dart';
import '../../utils/launch_url.dart';
import '../about/about_check_list_page.dart';
import '../widget_utils/app_bar/modal_bottom_sheet_app_bar_widget.dart';

class AboutAppMenusWidget extends StatefulWidget {
  const AboutAppMenusWidget({Key? key}) : super(key: key);

  @override
  State<AboutAppMenusWidget> createState() => _AboutAppMenusWidgetState();
}

class _AboutAppMenusWidgetState extends State<AboutAppMenusWidget> {
  final formKey = GlobalKey<FormState>();
  late List<Tile> aboutAppMenus;

  @override
  void initState() {
    super.initState();
    aboutAppMenus = generateAboutAppMenus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Tile> generateAboutAppMenus() {
    final launchUrl = LaunchUrl();
    return [
      Tile(
          leading: const Icon(Icons.checklist),
          title: const Text('成長のチェックリストについて'),
          onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AboutCheckListPage();
                }))
              }),
      Tile(
          leading: const Icon(Icons.security),
          title: const Text('プライバシーポリシー'),
          onTap: () => launchUrl.privacyPolicy()),
      Tile(
          leading: const Icon(Icons.description),
          title: const Text('利用規約'),
          onTap: () => launchUrl.termsOfService()),
      Tile(
          leading: const Icon(Icons.contact_mail),
          title: const Text('お問い合わせ'),
          onTap: () => launchUrl.contactForm()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: const ModalBottomSheetAppBarWidget(title: 'アプリについて'),
        body: SafeArea(
          child: ListView.builder(
              itemCount: aboutAppMenus.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: aboutAppMenus[index].leading,
                      title: aboutAppMenus[index].title,
                      trailing: const Icon(Icons.arrow_forward_ios),
                      iconColor: aboutAppMenus[index].isErrorText
                          ? Theme.of(context).colorScheme.error
                          : Colors.black87,
                      textColor: aboutAppMenus[index].isErrorText
                          ? Theme.of(context).colorScheme.error
                          : Colors.black87,
                      onTap: aboutAppMenus[index].onTap,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
