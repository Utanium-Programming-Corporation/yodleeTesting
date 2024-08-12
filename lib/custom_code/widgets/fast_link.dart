// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class FastLink extends StatefulWidget {
  const FastLink({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<FastLink> createState() => _FastLinkState();
}

class _FastLinkState extends State<FastLink> {
  final String accessToken = FFAppState().accessToken;
  final String fastLink = FFAppState().fastLink;
  final String extraParams = '';
  final webViewController = WebViewController();

  configureWebView() async {
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print(progress);
          },
        ),
      )
      ..addJavaScriptChannel(
        'YWebViewHandler',
        onMessageReceived: (JavaScriptMessage message) {
          _handleEventsFromJS(message.message);
        },
      )
      ..loadRequest(Uri.parse(Uri.dataFromString(await _loadFastLink(),
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString()));
  }

  @override
  void initState() {
    configureWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FastLink'),
      ),
      body: WebViewWidget(
        controller: webViewController,
      ),
    );
  }

  _loadFastLink() async {
    return '''<html>
            <body>
                  <form name="fastlink-form" action="$fastLink" method="POST">
                        <input name="accessToken" value="Bearer $accessToken" hidden="true" >
                        <input name="extraParams" value="$extraParams" hidden="true" />
                  </form>
                  <script type="text/javascript">
                        window.onload = function () {
                           document.forms["fastlink-form"].submit();
                        }
                  </script>
            </body>
            </html>''';
  }

  _handleEventsFromJS(message) {
    Map<String, dynamic> eventData = jsonDecode(message);

    // EventsInfoMap.add(eventData);
    if (eventData["type"] == "OPEN_EXTERNAL_URL") {
      String url = eventData["data"]["url"];
      _launchURL(url);
    }

    if (eventData["type"] == "POST_MESSAGE") {
      String action = eventData["data"]["action"];

      if (action == "exit") {
        //User has clicked the close button
        //You can close the WebView and navigate to the other screens
      }
    }
  }

  _launchURL(url) async {
    if (await canLaunchUrl(url)) {
      await launchURL(
        url,
      );
    } else {
      print('Could not launch ');
    }
  }
}
