//
//  JHCard.swift
//  ERS
//
//  Created by Joe Holt on 12/24/16.
//  Copyright © 2016 Joe Holt. All rights reserved.
//

import UIKit

class JHCard: NSObject {
    
    static let suits = ["♠️", "♣️", "♥️", "♦️"]
    static let values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    
    var suit: String!
    var value: String!
    var content: String {
        return suit + value
    }
    
    init(suit: String, value: String) {
        super.init()
        self.suit = suit
        self.value = value
    }

}
