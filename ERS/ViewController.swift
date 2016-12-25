//
//  ViewController.swift
//  ERS
//
//  Created by Joe Holt on 12/24/16.
//  Copyright © 2016 Joe Holt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    
    var uCard = UIPlayingCard() //UI Card
    
    var game: JHEgyption!
    var deck: JHDeck!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    //Perform slap action
    @IBAction func slapTapped(_ sender: UIButton) {
        let slapped = game.slapPile(player: game.players[0])
        //Card slap was successful, clear pile
        if slapped {
            slappedUI()
        }
    }
    
    //Perform play action
    @IBAction func playTapped(_ sender: UIButton) {
        playButton.isEnabled = false
        if uCard.label.isHidden == true {
            uCard.showCard()
        }
        gamesPlayer(player: game.players[0])
        computerPlayers()
    }
    
    //Updates UI in case of good slap
    func slappedUI() {
        if uCard.label.isHidden == false {
            uCard.hideCard()
        }
    }
    
    //Updates the cards UI
    func updateCardUI(forCard card: JHCard) {
        uCard.label.text = card.content
    }
    
    //Loops through time for computer players : Only set up for two players right now
    func computerPlayers() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.gamesPlayer(player: self.game.players[1])
            self.playButton.isEnabled = true
        }
    }
    
    //Logic for a game player
    func gamesPlayer(player: JHPlayer) {
        let card = player.deck.randomCard()
        game.playCard(card: card)
        updateCardUI(forCard: card)
    }
    
    //Sets up needed things at load
    func setUp() {
        //misc
        self.view.backgroundColor = UIColor.lightGray
        
        //Set up game
        let players = [JHPlayer(name: "Joe", deck: JHDeck(withCards: false)), JHPlayer(name: "Computer", deck: JHDeck(withCards: false))]
        deck = JHDeck(withCards: true)
        game = JHEgyption(players: players, deck: deck)
        
        //Set up card ui
        uCard = UIPlayingCard(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        uCard.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(uCard)
        let yCon = NSLayoutConstraint(item: uCard, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let aspectCon = NSLayoutConstraint(item: uCard, attribute: .width, relatedBy: .equal, toItem: uCard, attribute: .height, multiplier: 0.71428, constant: 0)
        let bottomCon = NSLayoutConstraint(item: uCard, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -230)
        let topCon = NSLayoutConstraint(item: uCard, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 200)
        NSLayoutConstraint.activate([yCon, aspectCon, bottomCon, topCon])
    }


}

