//
//  ViewController.swift
//  ERS
//
//  Created by Joe Holt on 12/24/16.
//  Copyright © 2016 Joe Holt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JHEgyptionDelegate {
    
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
        
    }
    
    //Perform play action
    @IBAction func playTapped(_ sender: UIButton) {
        //Flip card if it starts flipped over
        if !uCard.flipped {
            uCard.flipCard()
        }
        performTurn()
    }
    
    //Performs a turn with delay
    func nextTurn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performTurn()
        }
    }
    
    //Performs a turn
    func performTurn() {
        
        let (_, card, rWinner) = game.enactTurn()
        if let rCard = card {
            updateCardUI(forCard: rCard)
        }
        if let sWinner = rWinner {
            winner(player: sWinner)
        }
        
        //Only play next turn automatically if a computer is next
        if !game.userNext() {
            nextTurn()
        }
        
        
    }
    
    //Player one is about to make their move
    func userTurnWillBegin() {
        enablePlayButton(enabled: true)
    }
    
    //Player one just finished their move
    func userTurnDidEnd() {
        enablePlayButton(enabled: false)
    }
    
    //A special number of cards just finished
    func specialTurnsDidEnd() {
        
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
    
    //UI Winner Display
    func winner(player: JHPlayer) {
        let alert = UIAlertController(title: "\(player.name) Wins!", message: "Congrats, \(player.name), you win nothing!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: {
            //TODO
        })
    }
    
    //Sets up needed things at load
    func setUp() {
        //misc
        self.view.backgroundColor = UIColor.lightGray
        
        //Set up game
        let players = [JHPlayer(name: "Joe", deck: JHDeck(withCards: false)), JHPlayer(name: "Computer", deck: JHDeck(withCards: false))]
        deck = JHDeck(withCards: true)
        game = JHEgyption(players: players, deck: deck)
        game.delegate = self
        
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

