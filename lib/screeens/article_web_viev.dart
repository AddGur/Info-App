import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:info_app/services/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../consts/global_methods.dart';

class ArticleWebView extends StatefulWidget {
  final String url;
  const ArticleWebView({super.key, required this.url});

  @override
  State<ArticleWebView> createState() => _ArticleWebViewState();
}

class _ArticleWebViewState extends State<ArticleWebView> {
  late WebViewController _webViewController;

  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(IconlyLight.arrow_left),
            onPressed: () => Navigator.pop(context),
          ),
          iconTheme: IconThemeData(color: color),
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.url,
            style: TextStyle(color: color),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
                onPressed: () async {
                  return await _showModalSheetFct();
                },
                icon: const Icon(Icons.more_vert))
          ],
        ),
        body: Column(children: [
          LinearProgressIndicator(
            value: _progress,
            color: _progress == 1.0 ? Colors.transparent : Colors.green,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          Expanded(
              child: WebView(
            initialUrl: widget.url,
            zoomEnabled: true,
            onProgress: ((progress) {
              setState(() {
                _progress = progress / 100;
              });
            }),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
          )),
        ]),
      ),
    );
  }

  Future<void> _showModalSheetFct() {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
                width: 50,
                child: Divider(
                  thickness: 5,
                  color: Colors.grey,
                )),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'More options',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () async {
                try {
                  await Share.share(widget.url, subject: 'Look what I made!');
                } catch (err) {
                  GlobalMethods.errorDialog(
                      errorMessage: err.toString(), context: context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text('Open in browser'),
              onTap: () async {
                if (!await launchUrl(Uri.parse(widget.url))) {
                  throw 'Could not launch ${widget.url}}';
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh'),
              onTap: () async {
                try {
                  await _webViewController.reload();
                } catch (err) {
                  log("error occured $err");
                } finally {
                  Navigator.pop(context);
                }
              },
            ),
          ]),
        );
      },
    );
  }
}
