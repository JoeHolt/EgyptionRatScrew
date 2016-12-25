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
    var currentPlayer: Int = 0 {
        didSet {
            if currentPlayer + 1 > game.players.count {
                currentPlayer = 0
            }
        }
    }

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
        if game.players[0].deck.cards.count == 0 {
            winner(player: game.players[0])
        }
    }
    
    //Perform play action
    @IBAction func playTapped(_ sender: UIButton) {
        if uCard.label.isHidden == true {
            uCard.showCard()
        }
        gamesPlayer(player: game.players[0])
    }
    
    //Player clock
    func nextPlayer() {
        if currentPlayer == 0 {
            enablePlayButton(enabled: true)
        } else {
            enablePlayButton(enabled: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.gamesPlayer(player: self.game.players[self.currentPlayer])
            }
        }
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
    
    //Enable/Disable play button
    func enablePlayButton(enabled: Bool) {
        if !enabled {
            playButton.isEnabled = false
            playButton.backgroundColor = UIColor.red
        } else {
            playButton.isEnabled = true
            playButton.backgroundColor = UIColor.green
            
        }
    }
    
    //Logic for a game player
    func gamesPlayer(player: JHPlayer) {
        let card = player.deck.randomCard()
        if card.content != "??" {
            game.playCard(card: card)
            updateCardUI(forCard: card)
            currentPlayer += 1
            nextPlayer()
        } else {
            if player == game.players[0] {
                winner(player: player)
            } else {
                winner(player: game.players[1])
            }
        }
    }
    
    //Special card played
    func specialCard() {
        currentPlayer += 1
    }
    
    //Winner, not set up for more than two players
    func winner(player: JHPlayer) {
        //Winner found
        if game.players[0] == player {
            let alert = UIAlertController(title: "You lose", message: "Boo! You suck!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "I suck :(", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(alert, animated: true, completion: {
                //TODO
            })
        } else {
            let alert = UIAlertController(title: "Winner!", message: "Congrats! You win!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Wow!", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(alert, animated: true, completion: {
                //TODO
            })
        }
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

