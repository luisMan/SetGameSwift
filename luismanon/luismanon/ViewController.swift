//
//  ViewController.swift
//  SetGameLuisManon
//
//  Created by Luis Manon on 10/11/18.
//  Copyright © 2018 Niocoders. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet  var newGame: [UIButton]!
    @IBOutlet  var Peak: [UIButton]!
    @IBOutlet  var deal: [UIButton]!
    @IBOutlet var stackGrid: [UIStackView]!
    
    //our score counter variable to keep track of game score
    private(set) var gameScore = 0{
        didSet {
            updateAndStyleScore();
            
        }
    }
    
    //lets declare the score label
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet{
            //now lets call a function to update score
            updateAndStyleScore();
        }
    }
    
    func updateAndStyleScore(){
        var fColor : UIColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        fColor = fColor.withAlphaComponent(0.4)
        let attributes : [NSAttributedStringKey: Any] = [
            .foregroundColor: fColor,
            .strokeColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
            .strokeWidth: -3.0
        ]
        let attributedString = NSAttributedString(string: "Score: \(scoreLabel)",
            attributes: attributes)
        
        scoreLabel.attributedText = attributedString
    }
    
    
    //touch grid ui action listener
    @IBAction func touchCard(_ sender: UIButton) {
        
    }
    
    //touch new gsmr button function
    @IBAction func newGame(_ sender: UIButton){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

