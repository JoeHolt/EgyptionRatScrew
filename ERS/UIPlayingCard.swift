//
//  UIPlayingCard.swift
//  ERS
//
//  Created by Joe Holt on 12/24/16.
//  Copyright © 2016 Joe Holt. All rights reserved.
//

import UIKit

class UIPlayingCard: UIView {
    
    let label = UILabel()
    let radius: CGFloat = 15.0
    var flipped: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        layer.cornerRadius = radius
        backgroundColor = UIColor.white
        addBack()
        addLabel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Adds information label
    internal func addLabel() {
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        let xCon = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let yCon = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([xCon,yCon])
        label.isHidden = true //Starts flipped over so the label is hidden
    }
    
    //Adds image view to allow for card back to show
    internal func addBack() {
        backgroundColor = UIColor.black
    }
    
    //Flips card(toggle)
    internal func flipCard() {
        if label.isHidden {
            flipped = true
            backgroundColor = UIColor.white
            label.isHidden = false
        } else {
            flipped = false
            backgroundColor = UIColor.black
            label.isHidden = true
        }
    }
    
    //Shows card
    internal func showCard() {
        backgroundColor = UIColor.white
        label.isHidden = false
        isHidden = false
    }
    
    //Hides card(toggle)
    internal func hideCard() {
        if label.isHidden {
            isHidden = false
            label.isHidden = false
        } else {
            isHidden = true
            label.isHidden = true
        }
    }

}
