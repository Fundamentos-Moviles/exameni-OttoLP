import 'dart:math';
import 'package:flutter/material.dart';

class Examen extends StatefulWidget {
  const Examen({super.key});

  @override
  State<Examen> createState() => _ExamenState();
}

class _ExamenState extends State<Examen> {
  static const int gridSize = 6; // 6x6
  late List<String> board; // "grey", "green", "red" // Lista de colores 
  late Set<int> bombIndexes;
  bool gameOver = false; // bandera para parar el programa

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  //Funcion para reiniciar el juego
  void _resetGame() {
    board = List.generate(gridSize * gridSize, (index) => "grey");
    bombIndexes = {};
    Random random = Random();

    // Generar 2 bombas en posiciones únicas
    while (bombIndexes.length < 2) {
      bombIndexes.add(random.nextInt(gridSize * gridSize));
    }

    gameOver = false;
    setState(() {});
  }

  void _handleTap(int index) {
    if (gameOver) return;

    setState(() {
      if (bombIndexes.contains(index)) {
        board[index] = "red";
        gameOver = true;
      } else {
        board[index] = "green";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ancho disponible en pantalla
    final double screenWidth = MediaQuery.of(context).size.width;
    // Tamaño de cada celda ajustado al ancho total
    final double cellSize = (screenWidth - 32) / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscaminas de Bajo Presupuesto"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _resetGame,
            child: const Text("Reiniciar"),
          ),
          Expanded(
            child: Center(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(), // Sin scroll
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  childAspectRatio: 1, // Cuadrados perfectos
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  Color color;
                  if (board[index] == "grey") {
                    color = Colors.grey;
                  } else if (board[index] == "green") {
                    color = Colors.green;
                  } else {
                    color = Colors.red;
                  }

                  return InkWell(
                    onTap: () => _handleTap(index),
                    child: Container(
                      width: cellSize,
                      height: cellSize,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Alberto Otoniel Lopez Romero",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
