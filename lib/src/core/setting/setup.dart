import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import '../../../firebase_options.dart';
import '../storage/app_storage.dart';

String? accessToken;
bool isBloc = false;
int districtId = 1;

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  accessToken = await AppStorage.$read(key: StorageKey.accessToken);
  isBloc = await AppStorage.$readBool(key: StorageKey.isBlocked) ?? false;
}

const Map<int, String> bogTuri = {
  1: "Bog`",
  2: "Issiqxona",
  3: "Uzumzor",
};

const Map<int, String> qarorTuri = {
  1: "To`g'ridan to`gri",
  2: "Ochiq eletron tanlov asosida",
};

const Map<int, String> yerTuri = {
  1: "Lalmi",
  2: "Tog`oldi",
  3: "Adir",
  4: "Suvli maydon",
};

const Map<int, String> energyType = {
  1: "Limon",
  2: "Shpalier",
  3: "Kochat",
  4: "Quduq",
  5: "Tomchilatib",
  6: "Muqobilenergiya",
};
