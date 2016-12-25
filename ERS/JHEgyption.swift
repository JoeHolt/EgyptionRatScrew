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

class JHEgyption: NSObject {
    
    var pile: [JHCard] = []
    var players: [JHPlayer]! //Player 0 is always the user, others are computers
    
    init(players: [JHPlayer], deck: JHDeck) {
        self.players = players
        //Deal the cards between the players
        deck.shuffleDeck()
        while deck.cards.count > 0 {
            for player in players {
                if deck.cards.count > 0 {
                    player.deck.addCard(card: deck.randomCard(), atTop: false)
                }
            }
        }
        print("Initiated Egyption Rat Screw with \(players.count) players with about \(players[0].deck.cards.count) cards each")
    }
    
    //Play a card to the pile
    func playCard(card: JHCard) {
        pile.insert(card, at: 0)
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
    
    //Slap the pile, returns bool of wheather or not the slap was successful
    func slapPile(player: JHPlayer) -> Bool {
        //Check if valid
        if checkForDouble() {
            returnAndClearPile(player: player)
            return true
        } else if checkForSandwhich() {
            returnAndClearPile(player: player)
            return true
        } else {
            //Invalid slap
            pile.append(player.deck.randomCard())
            print("Pile slapped, \(player.name) lost a card")
            return false
        }
        
    }
    
    

}
