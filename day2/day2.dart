import 'dart:io';

void main() {
  var commands =
    File('day2.txt')
      .readAsLinesSync()
      .map((line) => Command.fromString(line))
      .toList();

  // part 1
  int position = 0;
  int depth = 0;
  for (Command command in commands) {
    switch (command.instruction) {
      case "forward":
        position += command.value;
        break;
      case "up":
        depth -= command.value;
        break;
      case "down":
        depth += command.value;
        break;
    }
  }
  print(position * depth);

  // part 2
  position = 0;
  depth = 0;
  int aim = 0;
  for (Command command in commands) {
    switch (command.instruction) {
      case "forward":
        position += command.value;
        depth += command.value * aim;
        break;
      case "up":
        aim -= command.value;
        break;
      case "down":
        aim += command.value;
        break;
    }
  }
  print(position * depth);
}


class Command {
  String instruction;
  int value;
  Command.fromString(String line) :
    instruction = line.split(' ')[0],
    value = int.parse(line.split(' ')[1]);
}
