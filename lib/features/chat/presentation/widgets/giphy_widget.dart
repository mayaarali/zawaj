import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class GiphyWidget extends StatelessWidget {
  final String giphyUrl;
  late WebViewXController webviewController;

  GiphyWidget({super.key, required this.giphyUrl});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: WebViewX(
          initialContent: giphyUrl,
          initialSourceType: SourceType.url,
          onWebViewCreated: (controller) => webviewController = controller,
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}
