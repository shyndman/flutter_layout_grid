import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLink extends StatelessWidget {
  UrlLink(
    this.url, {
    Key key,
    this.style,
    this.stripScheme = true,
  })  : assert(url.contains(':')),
        super(key: key);

  final String url;
  final TextStyle style;
  final bool stripScheme;

  String get label {
    if (!stripScheme) return url;

    return url.contains('://')
        ? url.substring(url.indexOf('://') + 3)
        : url.substring(url.indexOf(':') + 1);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launch(url),
        child: Text(label, style: style),
      ),
    );
  }
}
