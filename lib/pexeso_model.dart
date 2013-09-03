/**
 * A library that provides all logic for the pexeso game.
 */
library pexeso_model;

import 'package:shuffle/shuffle.dart';

/**
 * Returns randomly shuffled [List] of numbers 0..[numOfPairs]-1 containing each
 * number exactly twice.
 */
List<int> createShuffledCards(int numOfPairs) {
  var cards = [];
  for (var i = 0; i < numOfPairs; i++) {
    cards.add(i);
    cards.add(i);
  }
  return shuffle(cards);
}

/**
 * Class representing one play of the pexeso game.
 */
class Game {
  final int numPlayers;
  final List<int> score;
  final List cards;

  int playerOnTurn;

  /**
   * Creates new instance of [Game] with number [numPlayers] of players and with
   * pexeso cards [this.cards].
   */
  Game(numPlayers, this.playerOnTurn, this.cards)
      : this.numPlayers = numPlayers,
        score = new List.filled(numPlayers, 0);

  /**
   * Creates an instance of [Game] for number [numPlayers] of players and with
   * randomly shuffled [numOfPairs] pairs of cards.
   */
  factory Game.withCards(numPlayers, numOfPairs) {
    return new Game(numPlayers, 0, createShuffledCards(numOfPairs));
  }

  /**
   * Checks whether the [first] and [second] cards match and if so, increases
   * the score of [playerOnTurn] by 1 and return true. Otherwise return false
   * and update [playerOnTurn].
   */
  turnCards(int first, int second) {
    if (cards[first] == cards[second]) {
      score[playerOnTurn]++;
      return true;
    } else {
      playerOnTurn = (playerOnTurn + 1) % numPlayers;
      return false;
    }

  }
}