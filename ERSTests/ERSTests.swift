//
//  ERSTests.swift
//  ERSTests
//
//  Created by Joe Holt on 12/30/16.
//  Copyright © 2016 Joe Holt. All rights reserved.
//

import XCTest
@testable import ERS

class ERSTests: XCTestCase {
    
    var vc: ViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateInitialViewController() as! ViewController
        let _ = vc.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPlayers() {
        XCTAssert(vc.game.players.count > 0, "There is less than 1 player")
    }
    
    func testPile() {
        XCTAssert(vc.game.pile.count < 52, "The pile has too many cards")
        XCTAssert(vc.game.pile.count >= 0, "The pile has less than 0 cards")
    }
    
    func testSpecialCards() {
        XCTAssert(vc.game.specialCard < 4, "Special card is too high")
        XCTAssert(vc.game.specialCard >= 0, "Special card number bellow zero")
    }
    
    func testCurrentPlayer() {
        XCTAssert(vc.game.currentPlayer < vc.game.players.count, "Current player is higher than number of total players")
    }
    
    func testCheckForDouble() {
        vc.game.pile = [JHCard(suit: JHCard.suits[0], value: "1"), JHCard(suit: JHCard.suits[1], value: "1")]
        XCTAssert(vc.game.checkForDouble(), "Check for double does not return true when a correct double is there")
        vc.game.pile = [JHCard(suit: JHCard.suits[0], value: "1"), JHCard(suit: JHCard.suits[1], value: "2")]
        XCTAssert(!vc.game.checkForDouble(), "Check for double does not return false when a incorrect double is there")
    }
    
    func testCheckForSandwhich() {
        vc.game.pile = [JHCard(suit: JHCard.suits[0], value: "1"), JHCard(suit: JHCard.suits[1], value: "5"), JHCard(suit: JHCard.suits[0], value: "1")]
        XCTAssert(vc.game.checkForSandwhich(), "Check for sandwhich does not return true when a correct sandwhich is there")
        vc.game.pile =  [JHCard(suit: JHCard.suits[0], value: "1"), JHCard(suit: JHCard.suits[1], value: "5"), JHCard(suit: JHCard.suits[0], value: "7")]
        XCTAssert(!vc.game.checkForSandwhich(), "Check for sandwhich does not return false when a incorrect sandwhich is there")
    }
    
    func testReturnAndClearPileClears() {
        vc.game.returnAndClearPile()
        
    }
    
    
    
    
    
    
    
    
    
}
