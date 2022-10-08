import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:info_app/consts/api_consts.dart';
import 'package:info_app/models/news_model.dart';
import 'package:http/http.dart' as http;

class NewsApiServices with ChangeNotifier {
  static Future<List<NewsModel>> getAllNews(
      {required int page, required String sortBy}) async {
    try {
      var uri = Uri.https(BASEURLNEWS, "v2/everything", {
        "q": "bitcoin",
        "pageSize": "5",
        "domains": "bbc.co.uk, techcrunch.com, engadget.com",
        "page": page.toString(),
        "sortBy": sortBy
      });

      var response = await http.get(uri, headers: {'X-Api-key': API_KEY_NEWS});

      Map data = jsonDecode(response.body);

      List newsList = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var v in data['articles']) {
        newsList.add(v);
      }

      return NewsModel.newsFromSnapshot(newsList);
    } catch (e) {
      throw e.toString();
    }
  }
}
