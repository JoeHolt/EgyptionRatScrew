//
//  JHPlayer.swift
//  ERS
//
//  Created by Joe Holt on 12/24/16.
//  Copyright © 2016 Joe Holt. All rights reserved.
//

import UIKit

class JHPlayer: NSObject {

    var name: String
    var deck: JHDeck
    
    init(name: String, deck: JHDeck) {
        self.name = name
        self.deck = deck
    }
    
}
