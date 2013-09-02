/**
 * Memory game.
 */

import 'dart:html';
import 'dart:async';

import 'package:pexeso/pexeso_model.dart';

final List turnedCards = [];
Game game;

void main() {
  prepareGame();

}

void prepareGame() {
  game = new Game.withCards(2, 32);
  var container = query('#board');
  for (var i = 0; i < game.cards.length; i++) {
    new Card.withDom(container, "cards/back.jpg",
        "cards/${game.cards[i]}.jpg", i)
      ..onTurn.listen(onTurn);
  }
  updateScore();
}

void onTurn(Card card) {
  if (turnedCards.length >= 2) {
    for (var c in turnedCards) {
      c.turned = false;
    }
    turnedCards.clear();
  }

  turnedCards.add(card);
  if (turnedCards.length < 2) {
    return;
  }

  if (game.turnCards(turnedCards[0].id, turnedCards[1].id)) {
    turnedCards.clear();
  }

  updateScore();

}

void updateScore() {
  query('#score').text = "Player1: ${game.score[0]} Player2: ${game.score[1]}";
}

/**
 * Pexeso card representation.
 */
class Card {
  final HtmlElement element;
  final StreamController<Card> _onTurnController;
  final id;
  Stream<Card> get onTurn => _onTurnController.stream;

  bool _turned;
  bool get turned => _turned;
  void set turned (bool value) {
    _turned = value;
    element.classes.toggle('turned', value);
  }

  /**
   * Create the card around the DOM of [element] with an identificator [id].
   */
  Card(this.element, bool turned, this.id)
      : _onTurnController = new StreamController() {

    this.turned = turned;

    this.element.onClick.listen((event) {
      if (!this.turned) {
        this.turned = true;
        _onTurnController.add(this);
      }
    });
  }

  /**
   * Creates the card with DOM given the [backImage] and [frontImage] and
   * appends it to [container].
   */
  factory Card.withDom(Node container, String backImage, String frontImage, id) {
    var back = new ImageElement(src: backImage)
                ..className = 'back';
    var front = new ImageElement(src: frontImage)
                ..className = 'front';

    var div = new DivElement()
                ..className = 'pexeso-card'
                ..append(back)
                ..append(front);
    container.append(div);

    return new Card(div, false, id);
  }
}