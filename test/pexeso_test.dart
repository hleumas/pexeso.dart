/**
 * Unittests for pexeso game.
 */
library pexeso_test.dart;

import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';
import 'package:unittest/interactive_html_config.dart';
import '../web/pexeso.dart';
import 'package:pexeso/pexeso_model.dart';
import 'dart:html';

void main() {

  /** Uncomment the following line to try the interactive version of test */
  //useInteractiveHtmlConfiguration();

  group("Test of model.", () {
    test("Cards provided by createShuffledCards are enumerated from 0 to"
        " numOfPairs - 1 and each card is contained exactly twice.", () {
      expect(
        createShuffledCards(8),
        unorderedEquals([0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7])
      );

    });

    group("Turning cards", () {

      Game game;
      var numPlayers, playerOnTurn, nextPlayer;
      List cards;
      setUp(() {
        numPlayers = 4;
        playerOnTurn = 3;
        nextPlayer = 0;
        cards = [0, 1, 2, 0, 1, 2];
        game = new Game(numPlayers, playerOnTurn, cards);
      });

      test("that are the same increases the score by 1 and do not change the"
          " playerOnTurn. The return value is true.", () {
        expect(game.turnCards(0, 3), isTrue);
        expect(game.playerOnTurn, equals(playerOnTurn));
        expect(game.score[playerOnTurn], equals(1));
      });

      test("that do not match does not affect the score and next player gets"
          " turn. The return value is false.", () {
        expect(game.turnCards(0, 1), isFalse);
        expect(game.playerOnTurn, equals(nextPlayer));
        expect(game.score, orderedEquals(new List.filled(numPlayers, 0)));
      });
    });
  });

  group("Test of Card.", () {

    bool cardIsTurned(Card card) {
      return card.element.classes.contains('turned') && card.turned;
    }

    bool cardIsNotTurned(Card card) {
      !card.element.classes.contains('turned') && !card.turned;
    }

    test("Assigning to turn makes card turned on or off.", () {

      var card = new Card(new DivElement(), false, 10);
      expect(cardIsTurned(card), isFalse);
      card.turned = true;
      expect(cardIsTurned(card), isTrue);
      card.turned = false;
      expect(cardIsTurned(card), isFalse);
      card = new Card(new DivElement(), true, 10);
      expect(cardIsTurned(card), isTrue);
    });

    test("Cards not turned on turn on click and fire onTurn event.", () {
      var element = new DivElement();
      var card = new Card(element, false, 10);
      card.onTurn.listen(expectAsync1((e) => expect(e, equals(card))));
      element.click();
    });
  });

  group("Test of View.", () {

    var card1, card2, card3;
    setUp(() {
      game = new GameMock();
      card1 = new CardMock(true, 1);
      card2 = new CardMock(true, 2);
      card3 = new CardMock(true, 3);
    });

    tearDown(() {
      turnedCards.clear();
    });

    test("Turning third card on turns others non-matching off and the third"
        " card becomes the content of the turnedCards. There is no call to"
        " game.turnCards as there is still only one card waiting.", () {

      game.when(callsTo('turnCards')).alwaysReturn(false);

      onTurn(card1);
      onTurn(card2);
      game.getLogs(callsTo('turnCards', 1, 2)).verify(happenedOnce);

      onTurn(card3);

      expect(turnedCards, equals([card3]));
      expect(card1.turned, isFalse);
      expect(card2.turned, isFalse);

      game.getLogs(callsTo('turnCards')).verify(happenedOnce);
    });

    test("Turning third card when the previous form a matching pair does not"
        " hide them. There is exactly one call to game.turnCards with previous"
        " two cards as arguments. The content of turnedCards is the third card.", () {
      game.when(callsTo('turnCards')).alwaysReturn(true);

      onTurn(card1);
      onTurn(card2);
      game.getLogs(callsTo('turnCards', 1, 2)).verify(happenedOnce);

      onTurn(card3);

      expect(turnedCards, equals([card3]));
      expect(card1.turned, isTrue);
      expect(card2.turned, isTrue);
      game.getLogs(callsTo('turnCards')).verify(happenedOnce);

    });
  });
}


class CardMock extends Mock implements Card {
  bool turned;
  final id;

  CardMock(this.turned, this.id) : super();
}
class GameMock extends Mock implements Game {}