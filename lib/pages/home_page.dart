import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/bloc/news_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

enum PopUpItem { ru, uz, en }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    PopUpItem? item;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          icon: const Icon(Icons.language),
          initialValue: item,
          onSelected: (value) {
            item = value;
            if (item == PopUpItem.ru) {
              context.read<NewsBloc>().add(NewsLoadRuEvent());
            } else if (item == PopUpItem.uz) {
              context.read<NewsBloc>().add(NewsLoadUzEvent());
            } else {
              context.read<NewsBloc>().add(NewsLoadEnEvent());
            }
          },
          itemBuilder: (context) => <PopupMenuEntry<PopUpItem>>[
            const PopupMenuItem<PopUpItem>(
              value: PopUpItem.uz,
              child: Text('UZ'),
            ),
            const PopupMenuItem<PopUpItem>(
              value: PopUpItem.ru,
              child: Text('RU'),
            ),
            const PopupMenuItem<PopUpItem>(
              value: PopUpItem.en,
              child: Text('EN'),
            ),
          ],
        ),
        title: const Text(
          'Новости',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const NewsBodyWidget(),
          Positioned(
            top: 10,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 80,
              child: FloatingActionButton(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
                onPressed: () async {
                  final Uri url = Uri.parse('https://uzreport.news/');
                  try {
                    await launchUrl(url);
                  } catch (e) {
                    throw 'Could\'t launch $url';
                  }
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child:const Text(
                    'Ещё больше новостей - в нашем сайте',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewsBodyWidget extends StatelessWidget {
  const NewsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NewsLoadedState) {
          final item = state.newsFeed?.items;
          return Container(
            padding: const EdgeInsets.only(top: 0),
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return const SizedBox(height: 80);
                      }
                      return GestureDetector(
                        onTap: () async {
                          final Uri url = Uri.parse('${item?[i].link}');
                          try {
                            await launchUrl(url);
                          } catch (e) {
                            throw 'Could\'t launch $url';
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: '${item?[i].enclosure?.url}',
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 150,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 185),
                                child: Text(
                                  '${item?[i].title}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF000000),
                                    height: 25 / 16,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, i) => const SizedBox(height: 8),
                    itemCount: item?.length ?? 0,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
