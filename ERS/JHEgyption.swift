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
    func userTurnDidEnd()
    func clearPile(withDelay: Bool)
}

class JHEgyption: NSObject {
    
    static let specialValues: [String:Int] = ["A":4,"K":3,"Q":2,"J":1]
    
    var pile: [JHCard] = []             //Pile of cards that have been played
    var players: [JHPlayer]!            //Player 0 is always the user, others are computers
    var lastCard: JHCard?               //Last card to be played to the pile
    var specialCard: Int = 0            //Number of cards to play after a special card
    var specialPlayer: JHPlayer? = nil  //The player that played a "special" card and will recive the benifits
    var delegate: JHEgyptionDelegate?   //Delegate for game
    var cardsPlayed: Int = 0            //Number of cards played
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
                    player.deck.addCard(card: deck.randomCard()!, atTop: false)
                }
            }
        }
        print("Initiated Egyption Rat Screw with \(players.count) players with about \(players[0].deck.cards.count) cards each")
    }
    
    //Play a card to the pile
    internal func playCard(card: JHCard) {
        pile.insert(card, at: 0)
        if JHEgyption.specialValues.keys.contains(card.value) {
            specialCard = JHEgyption.specialValues[card.value]!
        }
        if checkForDouble() {
            //print("Two in a row slap possible: \(pile[0].content) and \(pile[1].content)")
        }
        if checkForSandwhich() {
            //print("Sandwhich slap possible: \(pile[0].content) and \(pile[2].content)")
        }
    }
    
    //Checks for two in a row
    internal func checkForDouble() -> Bool {
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
    internal func checkForSandwhich() -> Bool {
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
    internal func returnAndClearPile(player: JHPlayer) {
        print("Pile slapped, \(player.name) collected \(pile.count) cards")
        player.deck.addCards(cards: pile, atTop: false)
        pile = []
    }
    
    //Slap the pile, returns if a winner was created from the play and if the slap was successful
    internal func slapPile(player: JHPlayer) -> (Bool, JHPlayer?) {
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
    
    //Enacts a turn: Returns: (player, card played, winner)
    internal func enactTurn(special: Bool = false) -> (JHPlayer, JHCard?, JHPlayer?) {
        
        var specialPlayed = false   //Says if a special card was played this turn
        var winner: JHPlayer? = nil
        var rCard: JHCard? = nil
        let player = players[currentPlayer]
        
        //Play a card
        if let card = player.deck.randomCard() {
            rCard = card
            playCard(card: card)
            if JHEgyption.specialValues.keys.contains(card.value) {
                specialPlayed = true
                specialPlayer = player
                specialCard = JHEgyption.specialValues[card.value]!
            }
        }
        
        //Check for a winner
        if let pWinner = checkForWinner() {
            //A winner has been found
            winner = pWinner
        }
        
        advanceToNextTurn(specialPlayed: specialPlayed)
        cardsPlayed += 1
        return (player, rCard, winner)
    }
    
    //Advance to next turn
    internal func advanceToNextTurn(specialPlayed: Bool = false) {
        
        func delegateMethod() {
            if currentPlayer == 0 {
                delegate?.userTurnDidEnd()
            }
            if currentPlayer == players.count - 1 {
                delegate?.userTurnWillBegin()
            }
        }
       
        //Subtract one from special card if not played this turn
        if specialPlayed == false && specialCard > 0 {
            specialCard -= 1
            //Special card play finished
            if specialCard == 0 {
                //TODO: Make this function not allow player slapping until the pile has been collected
                if let player = specialPlayer {
                    returnAndClearPile(player: player)
                    delegate?.clearPile(withDelay: true)
                } else {
                    print("Special cards have no host player")
                }
            }
        }
        if specialPlayed == true || specialCard == 0 {
            delegateMethod()
            currentPlayer += 1
        }
        
    }
    
    //Special cards in play
    internal func specialCardsInPlay() -> Bool {
        if specialCard == 0 {
            return false
        } else {
            return true
        }
    }
    
    //Game checks for a winner, returns player if there is winner, nil otherwise
    internal func checkForWinner() -> JHPlayer? {
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
    
    //Check if next player is user
    internal func userNext() -> Bool {
        if currentPlayer == 0 {
            return true
        }
        return false
    }

}
