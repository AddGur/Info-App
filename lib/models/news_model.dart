import 'package:flutter/cupertino.dart';
import 'package:info_app/consts/global_methods.dart';

class NewsModel with ChangeNotifier {
  String? author,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      content,
      dateToShow;

  NewsModel(this.author, this.title, this.description, this.url,
      this.urlToImage, this.publishedAt, this.content, this.dateToShow);

  NewsModel.fromJson(Map<String, dynamic> json) {
    publishedAt = json['publishedAt'];

    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    content = json['content'];
    dateToShow = GlobalMethods.formattedDateText(publishedAt!);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['author'] = author;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['urlToImage'] = urlToImage;
    data['publishedAt'] = publishedAt;
    data['content'] = content;
    data['dateToShow'] = dateToShow;
    return data;
  }

  static List<NewsModel> newsFromSnapshot(List newsList) {
    return newsList.map((json) {
      return NewsModel.fromJson(json);
    }).toList();
  }
}
