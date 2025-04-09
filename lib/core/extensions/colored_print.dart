import 'package:chalk/chalk.dart';
import 'package:flutter/cupertino.dart';

extension Print on BuildContext {
  void printBlue(text) => debugPrint(chalk.blue('$text'));
  void printYellow(text) => debugPrint(chalk.yellow('$text'));
  void printGreen(text) => debugPrint(chalk.green('$text'));
  void printViolet(text) => debugPrint(chalk.magenta('$text'));
  void printRed(text) => debugPrint(chalk.red('$text'));
}
