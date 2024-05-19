import 'package:bloc/bloc.dart';
import 'package:dart_rss/domain/rss_feed.dart';
import 'package:meta/meta.dart';
import 'package:news_app/services/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;

  NewsBloc({required this.newsRepository}) : super(NewsInitial()) {
    on<NewsLoadRuEvent>(newsLoadRuEvent);
    on<NewsLoadUzEvent>(newsLoadUzEvent);
    on<NewsLoadEnEvent>(newsLoadEnEvent);
  }

  Future<void> newsLoadRuEvent(event, emit) async {
    emit(NewsLoadingState());
    try {
      final RssFeed? loadedNews = await newsRepository.getAllNews(lang: 'ru');
      emit(NewsLoadedState(newsFeed: loadedNews));
    } catch (e) {
      emit(NewsLoadingState());
    }
  }

  Future<void> newsLoadUzEvent(event, emit) async {
    emit(NewsLoadingState());
    try {
      final RssFeed? loadedNews = await newsRepository.getAllNews(lang: 'uz');
      emit(NewsLoadedState(newsFeed: loadedNews));
    } catch (e) {
      emit(NewsLoadingState());
    }
  }

  Future<void> newsLoadEnEvent(event, emit) async {
    emit(NewsLoadingState());
    try {
      final RssFeed? loadedNews = await newsRepository.getAllNews(lang: 'en');
      emit(NewsLoadedState(newsFeed: loadedNews));
    } catch (e) {
      emit(NewsLoadingState());
    }
  }
}
