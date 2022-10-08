import 'package:flutter/cupertino.dart';
import 'package:info_app/models/news_model.dart';
import 'package:info_app/services/news_api.dart';

class NewsProvider with ChangeNotifier {
  List<NewsModel> newsList = [];
  List<NewsModel> get getNewsList {
    return newsList;
  }

  Future<List<NewsModel>> fetchNews({
    required int currentPage,
  }) async {
    newsList = await NewsApiServices.getAllNews(
        page: currentPage, sortBy: 'relevancy');
    return newsList;
  }

  NewsModel findByDate({required String publishedAt}) {
    return newsList.firstWhere((element) => element.publishedAt == publishedAt);
  }
}
