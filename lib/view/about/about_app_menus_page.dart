import 'package:flutter/material.dart';

import '../../model/tile.dart';
import '../../utils/launch_url.dart';
import '../../utils/widget_utils.dart';

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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar(context, 'アプリについて'),
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
                  iconColor: aboutAppMenus[index].isErrorText ? Theme.of(context).errorColor : Colors.black87,
                  textColor: aboutAppMenus[index].isErrorText ? Theme.of(context).errorColor : Colors.black87,
                  onTap: aboutAppMenus[index].onTap,
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
