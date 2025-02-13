import "dart:async";
import "package:flutter/services.dart";
import "package:l/l.dart";

import "setup.dart";
import "app.dart";

void run() => l.capture<void>(
      () => runZonedGuarded<void>(
        () async {
          await setup();
          await SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp],
          );

          // App ni ishga tushirish
          App.run();
        },
        (final error, final stackTrace) {
          l.e(
            "io_top_level_error: $error\n $stackTrace",
            stackTrace,
          );
        },
      ),
      const LogOptions(
        printColors: true,
        handlePrint: true,
        outputInRelease: true,
      ),
    );
