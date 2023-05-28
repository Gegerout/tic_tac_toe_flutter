import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/utils/game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
        colorSchemeSeed: Colors.lightGreen
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  Game game = Game();

  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard();
  }

  @override
  Widget build(BuildContext context) {
    double borderWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "It's $lastValue turn".toUpperCase(),
            style: const TextStyle(color: Color(0xFF263A29), fontSize: 58),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: borderWidth,
            height: borderWidth,
            child: GridView.count(
                crossAxisCount: Game.boardlength ~/ 3,
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: List.generate(Game.boardlength, (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                            if (game.board![index] == "") {
                              setState(() {
                                game.board![index] = lastValue;
                                turn++;
                                gameOver = game.winnerCheck(
                                    lastValue, index, scoreboard, 3);
                                if (gameOver) {
                                  result = "$lastValue is the Winner!";
                                } else if (!gameOver && turn == 9) {
                                  result = "It's a Draw!";
                                  gameOver = true;
                                }
                                if (lastValue == "X") {
                                  lastValue = "O";
                                } else {
                                  lastValue = "X";
                                }
                              });
                            }
                          },
                    child: Container(
                      width: Game.blocSize,
                      height: Game.blocSize,
                      decoration: BoxDecoration(
                          color: const Color(0xff41644A),
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                              color: game.board![index] == "X"
                                  ? const Color(0xFFF2E3DB)
                                  : const Color(0xFFE86A33),
                              fontSize: 64),
                        ),
                      ),
                    ),
                  );
                })),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            result,
            style: const TextStyle(color: Color(0xFF263A29), fontSize: 54),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF41644A),
        onPressed: () {
          setState(() {
            game.board = Game.initGameBoard();
            lastValue = "X";
            gameOver = false;
            turn = 0;
            result = "";
            scoreboard = [0, 0, 0, 0, 0, 0, 0, 0, 0];
          });
        },
        child: const Icon(Icons.replay, color: Color(0xFFF2E3DB),),
      ),
    );
  }
}
