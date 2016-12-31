//
//  ERSViewTests.swift
//  ERS
//
//  Created by Joe Holt on 12/30/16.
//  Copyright © 2016 Joe Holt. All rights reserved.
//

import XCTest
@testable import ERS

class ERSViewTests: XCTestCase {
    
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
    
    func testPlayTapped() {
        vc.playTapped(UIButton())
        XCTAssert(vc.uCard.flipped)
    }
    
    
    
}
