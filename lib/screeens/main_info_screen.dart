import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_app/models/news_model.dart';
import 'package:info_app/models/weather_model.dart';
import 'package:info_app/providers/news_provider.dart';
import 'package:info_app/providers/weather_provider.dart';
import 'package:info_app/services/utils.dart';
import 'package:info_app/widgets/drawer_widget.dart';
import 'package:info_app/widgets/news_card.dart';
import 'package:info_app/widgets/loading_card_widget.dart';
import 'package:info_app/widgets/weather_card.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController _pageController;
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  int _currentPage = 1;

  @override
  void initState() {
    _pageController = PageController();
    _textController = TextEditingController(text: _currentPage.toString());
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // _pageController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(
      context,
    );
    final newsProvider = Provider.of<NewsProvider>(context);

    final Color color = Utils(context).getColor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Information app',
            style: GoogleFonts.dancingScript(color: color)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: color),
      ),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          Visibility(
            visible: !_focusNode.hasFocus,
            child: Expanded(
              flex: 2,
              child: FutureBuilder<List<WeatherModel>>(
                  future: weatherProvider.fetchWeather(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return PageView.builder(
                      controller: _pageController,
                      itemCount: snapshot.data!.length,

                      // padEnds: true,
                      //   allowImplicitScrolling: true,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: snapshot.data![index],
                          builder: (context, child) {
                            return Stack(
                              children: [
                                const WeatherCard(),
                                Positioned.fill(
                                    bottom: 20,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: DotsIndicator(
                                        decorator: DotsDecorator(
                                            activeColor: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        position:
                                            double.parse(index.toString()),
                                        dotsCount: snapshot.data!.length,
                                      ),
                                    ))
                              ],
                            );
                          },
                        );
                      },
                    );
                  }),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(children: [
              FutureBuilder<List<NewsModel>>(
                future: newsProvider.fetchNews(currentPage: _currentPage),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(child: LoadingWidget());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'No results for your categories ${snapshot.error}',
                      style: const TextStyle(fontSize: 20),
                    ));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: snapshot.data![index],
                            child: const NewsCard());
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _currentPage > 1
                                  ? Colors.blue
                                  : Colors.grey.shade400),
                          onPressed: _currentPage < 2
                              ? null
                              : () {
                                  setState(() {
                                    _currentPage--;
                                    _textController.text =
                                        _currentPage.toString();
                                  });
                                },
                          child: const Text('Previous'),
                        )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: SizedBox(
                        height: 40,
                        width: 60,
                        child: TextField(
                          decoration: InputDecoration(
                            isCollapsed: false,
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 3),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          controller: _textController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1)
                          ],
                          onEditingComplete: () {
                            setState(() {
                              if (int.parse(_textController.text) < 5) {
                                _currentPage = int.parse(_textController.text);
                              } else {
                                _currentPage = 5;
                                _textController.text = 5.toString();
                              }
                            });
                          },
                        ),
                      ),
                    )),
                    Expanded(
                        flex: 2,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: _currentPage < 5
                                    ? Colors.blue
                                    : Colors.grey.shade400),
                            onPressed: _currentPage > 4
                                ? null
                                : () {
                                    setState(() {
                                      _currentPage++;
                                      _textController.text =
                                          _currentPage.toString();
                                    });
                                  },
                            child: const Text('Next'))),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
