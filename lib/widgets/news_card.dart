import 'package:flutter/material.dart';
import 'package:info_app/models/news_model.dart';
import 'package:provider/provider.dart';

import '../screeens/inner_screen.dart/article_widget.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsModel>(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ArticleWidget.routeName,
            arguments: newsProvider.publishedAt);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 100,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Row(children: [
            SizedBox(
              width: 100,
              height: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                child: Hero(
                  tag: newsProvider.publishedAt!,
                  child: Image.network(
                    newsProvider.urlToImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      newsProvider.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text(newsProvider.dateToShow!),
                          const Spacer(),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 120),
                            child: Text(
                              newsProvider.author!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
          // child: ListTile(
          //   leading: Image.network(newsProvider.urlToImage!),
          // ),
        ),
      ),
    );
  }
}
