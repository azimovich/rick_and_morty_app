// import 'dart:io';

// void main() {
//   print('Start...');

//   final prompt = File('app-prompt.txt');
//   final yaml = File('pubspec.yaml');
//   final files = Directory('lib').listSync(recursive: true).where(
//     (e) {
//       if (e is File) {
//         if (!e.path.endsWith('.freezed.dart') &&
//             !e.path.endsWith('.g.dart') &&
//             !e.path.endsWith('.res.dart') &&
//             !e.path.endsWith('.config.dart') &&
//             e.path.lastIndexOf('/.') == -1) {
//           return true;
//         }
//       }
//       return false;
//     },
//   );

//   final sb = StringBuffer();
//   sb.writeln('pubspec.yaml');
//   sb.writeln("```yaml");
//   sb.writeln(yaml.readAsStringSync());
//   sb.writeln("```");
//   sb.writeln();
//   for (var e in files) {
//     sb.write(e.path);
//     sb.writeln("```dart");
//     sb.writeln(File(e.path).readAsStringSync());
//     sb.writeln("```");
//     sb.writeln();
//   }
//   prompt.writeAsStringSync(sb.toString());

//   print('Done');
// }
