import 'dart:html';

import 'package:dart_flex_unscrambler/dart_flex_unscrambler.dart';

void main() {
  MainApplication app = new MainApplication()
    ..wrapTarget(querySelector('#dart_flex_container'));
  
  window.onResize.listen(
    (_) {
      app.width = window.innerWidth;
      app.height = window.innerHeight;
    }
  );
}
