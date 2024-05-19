part of 'news_bloc.dart';

@immutable
sealed class NewsEvent {}

class NewsLoadRuEvent extends NewsEvent {}
class NewsLoadUzEvent extends NewsEvent {}
class NewsLoadEnEvent extends NewsEvent {}
