import 'package:checklist_child_grow_up/view/banner/ad_banner_widget.dart';
import 'package:checklist_child_grow_up/view/widget_utils/app_bar/app_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../model/tile.dart';
import '../../utils/launch_url.dart';

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

  @override
  void dispose() {
    super.dispose();
  }

  List<Tile> generateAboutAppMenus() {
    final launchUrl = LaunchUrl();
    return [
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
    return Scaffold(
      appBar: const AppBarWidget(title: 'アプリについて'),
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
      bottomNavigationBar: const AdBannerWidget(),
    );
  }
}
