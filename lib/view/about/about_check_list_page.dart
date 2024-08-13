import 'package:checklist_child_grow_up/view/widget_utils/app_bar/app_bar_widget.dart';
import 'package:flutter/material.dart';

import '../banner/ad_banner_widget.dart';

class AboutCheckListPage extends StatelessWidget {
  const AboutCheckListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: '成長のチェックリストについて'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 40.0),
                  child: Image.asset('assets/images/hiyoko_pen_skeleton.png',
                      height: 100)),
              const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                  child: Text(
                    '　成長のチェックリストは、わが子の成長の段階と、次のステップを知るために使います。月齢は目安です。'
                    '早ければ良いというわけではありません。',
                  )),
              const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                  child: Divider()),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 40.0),
                  child: Row(
                    children: [
                      Icon(Icons.bookmark,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: Text('成長のチェックリストの使い方',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Theme.of(context).colorScheme.secondary,
                                decorationThickness: 2.4)),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 40.0),
                child: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: const [
                      TextSpan(
                        text: '　まず、成長のチェックリストで、'
                            'わが子の月齢がどのような段階にあるのかを確認しましょう。'
                            'チェックリストは4つのジャンルにわかれています。\n',
                      ),
                      WidgetSpan(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          '\n　・ 体の大きな動き (からだ) \n　・ 手の動き (手のうごき) '
                          '\n　・ ことばの成長と理解 (ことば) \n　・ 生活習慣と社会的な成長 (せいかつ) ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                    ])),
              ),
              const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                  child: Text(
                    '　たとえば、わが子が生後5ヶ月だったとしましょう。チェックリストの5ヶ月を横に見ていきます。'
                    '「そろそろ、寝返りを打つころで、自分の手を見るようになり、話している人の目を見るようになり、'
                    '鏡に映るものに興味をしめすらしい」と、わが子の今の段階が見えてきます。',
                  )),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 26.0, horizontal: 40.0),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 40.0),
                child: Row(
                  children: [
                    Icon(Icons.bookmark,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 8.0),
                    Flexible(
                      child: Text('子どもの成長は早ければ良いというものではない',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Theme.of(context).colorScheme.secondary,
                              decorationThickness: 2.4)),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: Text('　「うちの子8カ月なのに、もう、つかまり立ちしようとしているわ！なんて早いんでしょう！'
                    '歩行器に座らせたら歩くんじゃないかしら？」、これは誤りです。'
                    '「子どもの成長は早ければ良い！」という考えは捨てましょう。'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 40.0),
                child: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: const [
                      TextSpan(
                        text: '「次の段階へのステップは、その前の段階をいかに充実して経験してきたかにかかっている」',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'これは、モンテッソーリの「スモールステップス」の考え方です。'),
                    ])),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: Text(
                  '　ハイハイの期間が長くても、それには理由があるのです。今は、両手で床をしっかり押して、'
                  'お尻を上げて、ハイハイを一生懸命練習している最中なのです。'
                  'この段階が充実してこそ、次のつかまり立ちに移っていけるのです。大人が早くて歩いて欲しいからといって、'
                  '抱き上げて歩行器に入れれば、偶然、歩くかもしれませんが、「つかまり立ち → 伝い歩き → 一人立ち」という、'
                  '発達のステップを飛ばしてしまうことになります。その結果、仮に歩くことができるようになったとしても、'
                  '体幹が育たず、バランスもとれずに、その先のステップで必ず弊害が出てきてしまうのです。',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 40.0),
                child: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: const [
                      TextSpan(text: '　ですから、'),
                      TextSpan(
                        text: '成長のチェックリストは、わが子の今を見つめ、'
                            '今を充実して過ごしてあげられるように活用してください。',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ])),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: Text(
                  '　その上で、次の成長段階に目を向けます。時が来れば、子どもは自分の判断で、'
                  '次のステップへと進みます。それは大人が強制できるものではありません。大人にできるのは、'
                  '「子どもが一人でできるようにお手伝いすること」だけなのです。',
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                child: Text(
                  '　今、ハイハイを一生懸命していたら、次のつかまり立ちに移行しやすいように、'
                  '適切な高さで安定性の良い棚などを、そっと置いておいてあげる。これが環境を整えるということなのです。'
                  'このようにチェックリストは次の成長のステップを知るために活用してください。',
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 26.0, horizontal: 40.0),
                child: Divider(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
                child: Text(
                  '( 出典: 藤崎達宏、'
                  '『０～３歳までの実践版 モンテッソーリ教育で才能をぐんぐん伸ばす！』、'
                  '三笠書房、 2018、p.246、(ISBN: 9784837927525) )',
                ),
              ),
            ]),
          ),
        ),
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }
}
