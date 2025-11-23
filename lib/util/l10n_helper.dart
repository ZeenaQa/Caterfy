import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/main.dart';

class L10n {
  static AppLocalizations get t {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) {
      throw Exception("Localization accessed before context is available");
    }
    return AppLocalizations.of(ctx);
  }
}
