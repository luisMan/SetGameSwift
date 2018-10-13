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
    @IBOutlet var stackGrid: UIStackView!
    
    //pointer variable for our game data model :-)
    private var game =  GameDataModel()
    
    
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
        let attributedString = NSAttributedString(string: "Score: \(game.score)",
            attributes: attributes)
        
        scoreLabel.attributedText = attributedString
    }
    
    //the update parent stack view is just a function that I have created to add the buttons dynamically to the parent stack
    func upDateParentStackView(buttons: [UIButton]){
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.backgroundColor =  UIColor.red;
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //now lets add this pack view to the main stack grid which is vertical lol
        stackGrid.addSubview(stackView)
    }
    
    //this function is to initialize my game buttons dynamically
    func initGameUiButtons(initDecks: Int)
    {
        var card = game.cardDeckObject()
        var counter=1;
        var buttons = [UIButton]()
        
         for _ in 1...initDecks {
            
            if(!game.cardDeckObject().isDeckEmpty()){
                
                if counter % 4 != 0 {
                 //retrieve the card
                let cardObject =  card.dealCard()
                let newButton =  UIButton(type: .system)
                    newButton.setTitle(
                        "hello",
                        for: .normal)
                    newButton.accessibilityAttributedValue = cardObject?.attributedContents()
                    buttons.append(newButton)
                //reset the counter to 1
                    counter = 1
                }else{
                    //lets save the buttons to the child stack view
                    print("the size of my first stack buttons  = \(buttons.count)")
                    upDateParentStackView(buttons: buttons)
                    //reset the button array
                    buttons = [UIButton]()
                    counter = counter + 1
                }
            }
            
        }
    }
    
    //touch grid ui action listener
    @IBAction func touchCard(_ sender: UIButton) {
        
    }
    
    //touch new gsmr button function
    @IBAction func newGame(_ sender: UIButton){
         initGameUiButtons(initDecks: 12);
    }
    //touch peak button function
    @IBAction func peak(_ sender: UIButton){
        
    }
    
    //touch new gsmr button function
    @IBAction func dealCards(_ sender: UIButton){
        
    }
    
    
    func example(){
       
        let a = UIView()
        a.backgroundColor = UIColor.red
        let heightConstraintA = a.heightAnchor.constraint(equalToConstant: 120.0)
        heightConstraintA.isActive = true
        heightConstraintA.priority = UILayoutPriority(rawValue: 999)
        a.widthAnchor.constraint(equalToConstant: 320).isActive = true
        a.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stackView = UIStackView()
        stackView.addArrangedSubview(a)
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackGrid.addArrangedSubview(stackView)
        
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        // Do any additional setup after loading the view, typically from a nib.
        //if the view loaded then lets show decks
        example();
       // initGameUiButtons(initDecks: 12)
    }
    
    
}

