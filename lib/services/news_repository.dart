import 'package:dart_rss/dart_rss.dart';
import 'package:news_app/services/api.dart';

class NewsRepository {
  Future<RssFeed?> getAllNews({String? lang}) => Api.getDataRss(lang: lang);
}
