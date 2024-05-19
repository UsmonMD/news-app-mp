import 'package:dart_rss/domain/rss_feed.dart';
import 'package:news_app/model/news.dart';
import 'package:http/http.dart' as http;

class Api {
  static List<News> newsList = [];
  static RssFeed? rssData;

  static Future<RssFeed?> getDataRss({String? lang}) async {
    final url = Uri.parse('https://uzreport.news/feed/rss/$lang');
    final response = await http.get(url);

    rssData = RssFeed.parse(response.body);
    if (response.statusCode == 200) {
      for (var item in rssData!.items) {
        newsList.add(
          News(
            title: item.title ?? '',
            description: item.description ?? '',
            date: item.pubDate ?? '',
            link: item.link ?? '',
            imageUrl: item.enclosure?.url ??
                'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
          ),
        );
      }
    } else {
      throw Exception("Error ${response.statusCode}");
    }

    return rssData;
  }
}
