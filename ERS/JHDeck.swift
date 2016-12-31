//
//  JHDeck.swift
//  ERS
//
//  Created by Joe Holt on 12/24/16.
//  Copyright © 2016 Joe Holt. All rights reserved.
//

import UIKit
import GameplayKit

class JHDeck: NSObject {
    
    var cards: [JHCard] = []
    
    init(withCards: Bool) {
        super.init()
        if withCards {
            for suit in JHCard.suits {
                for value in JHCard.values {
                    let card = JHCard(suit: suit, value: value)
                    cards.append(card)
                }
            }
        }
    }
    
    //Add a singular card to deck
    internal func addCard(card: JHCard, atTop: Bool) {
        addCards(cards: [card], atTop: atTop)
    }
    
    //Add cards to deck
    internal func addCards(cards: [JHCard], atTop: Bool) {
        //Cards inserted at top or bottom
        if atTop {
            self.cards.insert(contentsOf: cards, at: 0)
        } else {
            self.cards.append(contentsOf: cards)
        }
    }
    
    //Remove card at specified index
    internal func removeCard(atIndex index: Int) {
        if cards.count < index || cards.count > 0 {
            cards.remove(at: index)
        } else {
            print("ERROR: Could not remove card at index, out of bounds")
        }
    }
    
    //Return and remove card at specified index, returns nil if no cards remain
    internal func cardAtIndex(index: Int) -> JHCard? {
        if cards.count < index && cards.count > 0 {
            let card = cards[index]
            removeCard(atIndex: index)
            return card
        } else {
            return nil
        }
    }
    
    //Return and remove card at random index, returns nil if no cards remain
    internal func randomCard() -> JHCard? {
        if cards.count > 0 {
            let index: UInt32 = arc4random_uniform(UInt32(cards.count - 1))
            let card = cards[Int(index)]
            removeCard(atIndex: Int(index))
            return card
        } else {
            return nil
        }
        
    }
    
    //Shuffles the deck
    internal func shuffleDeck() {
        cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [JHCard]
    }

}
