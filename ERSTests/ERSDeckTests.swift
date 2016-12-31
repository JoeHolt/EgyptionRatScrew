//
//  ERSDeckTests.swift
//  ERS
//
//  Created by Joe Holt on 12/30/16.
//  Copyright © 2016 Joe Holt. All rights reserved.
//

import XCTest
@testable import ERS

class ERSDeckTests: XCTestCase {
    
    var deck: JHDeck!
    
    override func setUp() {
        deck = JHDeck(withCards: true)
    }
    
    override func tearDown() {
        
    }
    
    func testInit() {
        XCTAssert(deck.cards.count == 52, "Deck doesnt init with 52 cards")
    }
    
    func testAddCard() {
        deck.addCard(card: JHCard(suit: JHCard.suits[0], value: "1"), atTop: false)
        XCTAssert(deck.cards.count == 53)
    }
    
    func testAddCards() {
        let cards = [JHCard(suit: JHCard.suits[0], value: "1"), JHCard(suit: JHCard.suits[0], value: "2"), JHCard(suit: JHCard.suits[0], value: "3")]
        deck.addCards(cards: cards, atTop: false)
        XCTAssert(deck.cards.count == 55)
    }
    
    func testRemoveCard() {
        deck.removeCard(atIndex: 0)
        XCTAssert(deck.cards.count == 51)
    }
    
    func testAddCardAtIndex() {
        let card = deck.cardAtIndex(index: 0)
        XCTAssert(card?.content == "♠️A", "Cards Content: \(card?.content)")
    }
    
}
