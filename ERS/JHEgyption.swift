//
//  JHEgyption.swift
//  ERS
//
//  Created by Joe Holt on 12/24/16.
//  Copyright © 2016 Joe Holt. All rights reserved.
//

import UIKit

/* Egyption Rat Screw is a game where you play a series of cards.
 * You then slap in given circumstances, if a face card or ace is
 * played then new rules occur, the goal is to have all of the cards
 */

protocol JHEgyptionDelegate {
    func userTurnWillBegin()
    func userTurnDidStart()
    func userTurnDidEnd()
}

class JHEgyption: NSObject {
    
    static let specialValues: [String:Int] = ["A":4,"K":3,"Q":2,"J":1]
    
    var pile: [JHCard] = []             //Pile of cards that have been played
    var players: [JHPlayer]!            //Player 0 is always the user, others are computers
    var lastCard: JHCard?               //Last card to be played to the pile
    var specialCard: Int = 0            //Number of cards to play after a special card
    var delegate: JHEgyptionDelegate?   //Delegate for game
    var currentPlayer: Int = 0 {        //Current player - Loop back to start if gone too far
        didSet {
            if currentPlayer > players.count - 1 {
                currentPlayer = 0
            }
        }
    }
    
    init(players: [JHPlayer], deck: JHDeck) {
        self.players = players
        //Deal the cards between the players
        deck.shuffleDeck()
        while deck.cards.count > 0 {
            for player in players {
                if deck.cards.count > 0 { //Only continue if cards are left
                    print("Deck making")
                    player.deck.addCard(card: deck.randomCard()!, atTop: false)
                }
            }
        }
        print("Initiated Egyption Rat Screw with \(players.count) players with about \(players[0].deck.cards.count) cards each")
    }
    
    //Play a card to the pile
    func playCard(card: JHCard) {
        pile.insert(card, at: 0)
        if JHEgyption.specialValues.keys.contains(card.value) {
            specialCard = JHEgyption.specialValues[card.value]!
            print("\(card.content) played")
        }
        if checkForDouble() {
            print("Two in a row slap possible: \(pile[0].content) and \(pile[1].content)")
        }
        if checkForSandwhich() {
            print("Sandwhich slap possible: \(pile[0].content) and \(pile[2].content)")
        }
    }
    
    //Checks for two in a row
    func checkForDouble() -> Bool {
        if pile.count >= 2 {
            if pile[0].value == pile[1].value {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    //Checks for sandwich
    func checkForSandwhich() -> Bool {
        if pile.count >= 3 {
            if pile[0].value == pile[2].value {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    //Returns the pile and clears it
    private func returnAndClearPile(player: JHPlayer) {
        print("Pile slapped, \(player.name) collected \(pile.count) cards")
        player.deck.addCards(cards: pile, atTop: false)
        pile = []
    }
    
    //Slap the pile, returns if a winner was created from the play and if the slap was successful
    func slapPile(player: JHPlayer) -> (Bool, JHPlayer?) {
        var winner: JHPlayer? = nil
        var successeful: Bool = false
        //Check if valid
        if checkForDouble() || checkForSandwhich() {
            //Valid slap
            successeful = true
            returnAndClearPile(player: player)
        } else {
            //Invalid slap
            if let card = player.deck.randomCard() {
                pile.append(card)
                print("Pile slapped, \(player.name) lost a card")
            } else {
                print("Pile slapped, \(player.name) had no cards remaining")
            }
            //Check if slap resulted in a winner
            if let pWinner = checkForWinner() {
                winner = pWinner
            }
        }
        return (successeful, winner)
    }
    
    //Enact a turn, if turn results in winner, said winner is returned, the played card is also returned
    func enactTurn() -> (JHCard?, JHPlayer?) {
        if currentPlayer == 0 {
            delegate?.userTurnDidStart()
        }
        var winner: JHPlayer? = nil
        var rCard: JHCard? = nil
        let player = players[currentPlayer]
        if let card = player.deck.randomCard() {
            rCard = card
            playCard(card: card)
        }
        if let pWinner = checkForWinner() {
            //A winner has been found
            winner = pWinner
        }
        if currentPlayer == 0 {
            delegate?.userTurnDidEnd()
        }
        if currentPlayer == players.count - 1 {
            delegate?.userTurnWillBegin()
        }
        currentPlayer += 1
        return (rCard, winner)
    }
    
    //Game checks for a winner, returns player if there is winner, nil otherwise
    func checkForWinner() -> JHPlayer? {
        var playersWithCards: [JHPlayer] = []
        for player in players {
            if player.deck.cards.count > 0 {
                playersWithCards.append(player)
            }
        }
        if playersWithCards.count == 1 {
            print(playersWithCards[0].name, " won")
            return playersWithCards[0]
        } else {
            return nil
        }
    }
    
    //
    
    

}
