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
    @IBOutlet weak var playerOneDisplay: UILabel!   //Displays how many cards are left for player one
    @IBOutlet weak var playerTwoDisplay: UILabel!   //Displays how many cards are left for player two
    @IBOutlet weak var turnDisplay: UILabel!        //Displays how many turns there have been
    @IBOutlet weak var timeDisplay: UILabel!        //Displays reaction time
    @IBOutlet weak var totalDisplay: UILabel!
    
    var uCard = UIPlayingCard() //UI Card
    var game: JHEgyption!
    var deck: JHDeck!
    var delay: Double = 0.5
    var delayNextTurn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
    
    //Updates player labels
    internal func updateLabels() {
        playerOneDisplay.text = "Player 1 cards: \(game.players[0].deck.cards.count)"
        playerTwoDisplay.text = "Player 2 cards: \(game.players[1].deck.cards.count)"
        totalDisplay.text = "Total: \(game.players[0].deck.cards.count + game.players[1].deck.cards.count + game.pile.count)"
        turnDisplay.text = "Turns: \(game.cardsPlayed)"
    }
    
    //Performs a turn with delay
    internal func nextTurn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.performTurn()
        }
    }
    
    //Performs a turn
    internal func performTurn() {
        
        let (_, card, rWinner) = game.enactTurn()
        if let rCard = card {
            updateCardUI(forCard: rCard)
        }
        if let sWinner = rWinner {
            winner(player: sWinner)
        }
        
        
        //Only play next turn automatically if a computer is next
        //TODO: The delay next turn delay helps solve issues but is not always needed because it adds uneeded delay
        if !game.userNext() {
            if delayNextTurn == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.nextTurn()
                }
                delayNextTurn = false
            } else {
                nextTurn()
            }
        }
        
        updateLabels()
        
    }
    
    //Player one is about to make their move
    internal func userTurnWillBegin() {
        enablePlayButton(enabled: true)
    }
    
    //Player one just finished their move
    internal func userTurnDidEnd() {
        enablePlayButton(enabled: false)
    }
    
    //Game requests a slap
    internal func clearPile(withDelay: Bool) {
        print("Pile requestested to be cleared")
        delayNextTurn = true    //Delay next turn
        if withDelay {
            print("with a dealy")
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.slappedUI()
            }
        } else {
            slappedUI()
        }
    }
    
    //Updates UI in case of good slap
    internal func slappedUI() {
        if uCard.label.isHidden == false {
            uCard.hideCard()
        }
    }
    
    //Updates the cards UI
    internal func updateCardUI(forCard card: JHCard) {
        if uCard.isHidden {
            uCard.showCard()
        }
        uCard.label.text = card.content
    }
    
    //Enable/Disable play button
    internal func enablePlayButton(enabled: Bool) {
        if !enabled {
            playButton.isEnabled = false
            playButton.backgroundColor = UIColor.red
        } else {
            playButton.isEnabled = true
            playButton.backgroundColor = UIColor.green
            
        }
    }
    
    //UI Winner Display
    internal func winner(player: JHPlayer) {
        let alert = UIAlertController(title: "\(player.name) Wins!", message: "Congrats, \(player.name), you win nothing!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: {
            //TODO
        })
    }
    
    //Sets up needed things at load
    internal func setUp() {
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

