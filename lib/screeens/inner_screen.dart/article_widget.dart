import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:info_app/providers/news_provider.dart';
import 'package:info_app/screeens/article_web_viev.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ArticleWidget extends StatefulWidget {
  static const routeName = '/ArticleWidget';

  const ArticleWidget({super.key});
  @override
  State<ArticleWidget> createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
  String? publishedAt;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    publishedAt = ModalRoute.of(context)!.settings.arguments as String;
    final newsProvider = Provider.of<NewsProvider>(context);
    final currentNews = newsProvider.findByDate(publishedAt: publishedAt!);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            Stack(
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Hero(
                      tag: publishedAt!,
                      child: Image.network(
                        currentNews.urlToImage!,
                        fit: BoxFit.fitWidth,
                      ),
                    )),
                Positioned(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Card(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          IconlyLight.arrow_left_2,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {},
                        child: const Card(
                          elevation: 10,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              IconlyLight.send,
                              size: 28,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {},
                        child: const Card(
                          elevation: 10,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              IconlyLight.bookmark,
                              size: 28,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              currentNews.title!,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    currentNews.dateToShow!,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Spacer(),
                  if (currentNews.author != null)
                    Text(currentNews.author!,
                        style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            Text(
              currentNews.content!,
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(
              thickness: 2,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: ArticleWebView(url: currentNews.url!),
                        type: PageTransitionType.leftToRight,
                        inheritTheme: true,
                        ctx: context));
              },
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text('source: ${currentNews.url!}')),
            )
          ]),
        ),
      ),
    );
  }
}
