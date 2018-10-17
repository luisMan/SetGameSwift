//
//  ViewController.swift
//  SetGameLuisManon
//
//  Created by Luis Manon on 10/11/18.
//  Copyright © 2018 Niocoders. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet  var newGame: UIButton!
    @IBOutlet  var Peak: [UIButton]!
    @IBOutlet  var deal: UIButton!
    @IBOutlet var viewButtons: [UIButton]!
    
    public var objectToFlush = [UIButton]()
    public var reArrangeButtons: Bool  = false
    
    //ingame boolean
    var inGame: Bool = false
    var timer: Timer!
    var counterOnPeak: Int = 12
    var itemsRemovedOnArrangements: Int = 0
    
    var gameCollection = Dictionary<UIButton, ModelCards>()
    
    var gameSetBasket  = Dictionary<UIButton, ModelCards>()
    
    //pointer variable for our game data model :-)
    private lazy var game =  GameDataModel(type: self)
    
    
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
            .strokeColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            .strokeWidth: -3.0
        ]
        let attributedString = NSAttributedString(string: "Score: \(game.score)",
            attributes: attributes)
        
        scoreLabel.attributedText = attributedString
    }
  
    
    //this function is to initialize my game buttons dynamically
    func initGameUiButtons(initDecks: Int)
    {
        gameCollection.removeAll()
        var card = game.cardDeckObject()
        
         for index in 0..<initDecks {
            
            if(!game.cardDeckObject().isDeckEmpty()){
                let cardObject =  card.dealCard()
                viewButtons[index].isEnabled  = true;
                viewButtons[index].isHidden = false;
                viewButtons[index].setAttributedTitle(cardObject?.attributedContents(), for: UIControlState.normal)
                viewButtons[index].backgroundColor = UIColor.white
                //insert this nice item to my dictionary
                gameCollection.updateValue(cardObject!, forKey: viewButtons[index])
            }
        }
        
    }
    
    //function return my own visible game collection for all cards
    func getGameCollectionUI() -> Dictionary<UIButton, ModelCards> {
    return self.gameCollection
    }
    //get the game object basket
    func getGameSetBasket() -> Dictionary<UIButton, ModelCards> {
        return self.gameSetBasket
    }
    
    //can deal more Cards
    func canDealMoreCards() -> Bool {
        if counterOnPeak < 24 {
        return true
        }
        
    return false
    }
    
    @IBAction func toggle_buttons(_ sender: UIButton){
       //lets get the buttons from the hashable key and put it on a basket
        if(inGame){
            sender.backgroundColor = UIColor.gray
            gameSetBasket.updateValue(gameCollection[sender]!, forKey: sender)
           if(gameSetBasket.count == 3){
            //we have a full basket then lets call our gameDataModel object to check if there is a set
            game.ComputeSet()
            //empty basket and remove all highlighted colors for the ui
            gameSetBasket.removeAll()
            //flush the color
        }
        }else{
             let startGame = UIAlertController(title: "SetGame", message: "Please start Game to play!", preferredStyle: .alert)
            let gameAction = UIAlertAction(title: "play", style: .destructive) { (alert: UIAlertAction!) -> Void in
                self.inGame = !self.inGame
                self.newGame.setTitle("InGame", for: .normal)
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                
            }
            startGame.addAction(gameAction)
            present(startGame, animated: true, completion:nil)
        }
        
        
    }
    
    //flush all the color of the grid to be default colors
    func flushColor()
    {
        for  index in viewButtons.indices
        {
            if !viewButtons[index].isHidden {
            viewButtons[index].backgroundColor = UIColor.white
            }
        }
    }
    
    //touch new gsmr button function
    @IBAction func newGame(_ sender: UIButton){
         inGame = true
        self.newGame.setTitle("InGame", for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
         initGameUiButtons(initDecks: 12);
    }
    //touch peak button function
    @IBAction func peak(_ sender: UIButton){
    
    }
    
    
    //touch new gsmr button function
    @IBAction func dealCards(_ sender: UIButton){
        var counter = 0;
        if inGame && canDealMoreCards() {
            print("deal Card ")
            var card = game.cardDeckObject()
            for index in 0..<3{
                if(!game.cardDeckObject().isDeckEmpty()){
                    let num =  counterOnPeak + index
                    let cardObject =  card.dealCard()
                    viewButtons[num].isEnabled  = true;
                    viewButtons[num].isHidden = false;
                    viewButtons[num].setAttributedTitle(cardObject?.attributedContents(), for: UIControlState.normal)
                    viewButtons[num].backgroundColor = UIColor.white
                    //insert this nice item to my dictionary
                    gameCollection.updateValue(cardObject!, forKey: viewButtons[num])
                    
                    //increment counter
                    counter = counter + 1;
                  }//close if empty
            }
            
            counterOnPeak = counterOnPeak + counter;
        }
    }
    
    //lets disable our buttons
    func disableButtons()
    {
        for index in viewButtons.indices {
            viewButtons[index].isHidden = true;
            viewButtons[index].isEnabled = false;
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        //disable buttons
        disableButtons();
        // Do any additional setup after loading the view, typically from a nib.
        initGameUiButtons(initDecks: 12)
       
    }
    
    //disable a button
    func disableButton(sender: UIButton){
      //  for index in objectToFlush.indices {
            let attributes: [NSAttributedStringKey: Any] = [
                .strokeColor: UIColor.black,
                .foregroundColor: UIColor.red.withAlphaComponent(0.0),
                .strokeWidth: -5.0
            ]//close of attibutes
            let attributedString = NSAttributedString(string:" ",attributes: attributes)
            sender.setAttributedTitle(attributedString,for: UIControlState.normal)
            sender.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            sender.isEnabled = false
       // }
    }
    
    //because I love challenges and this is one of the task i will create rearrange the grid :-)
    func reArrangeGridAndDisableButtons(buttons: [UIButton], pivot: Int, end: Int){
        let mid =  counterOnPeak/2
        if pivot <= mid && mid <= end{
            if !buttons[pivot].isEnabled && buttons[end].isEnabled {
                buttons[pivot].backgroundColor = UIColor.white
                buttons[pivot].setAttributedTitle(gameCollection[buttons[end]]!.attributedContents(), for: UIControlState.normal)
                    buttons[pivot].isEnabled = true
                    //ADD THIS NEW VALUE FOR COLLETION
               gameCollection.updateValue(gameCollection[buttons[end]]!, forKey: buttons[pivot])
                //LETS REMOVE THIS END BUTTON FROM COLLECTION :-)
                gameCollection.removeValue(forKey: buttons[end])
                //now disable the end
                disableButton(sender: buttons[end])
                //update the item remove on Arrangements
                self.itemsRemovedOnArrangements = itemsRemovedOnArrangements + 1
                //recursive call
               let p = pivot + 1
               let e =  end - 1
                reArrangeGridAndDisableButtons(buttons : buttons, pivot: p, end: e)
            }else if buttons[pivot].isEnabled && buttons[end].isEnabled {
                let p = pivot + 1
                reArrangeGridAndDisableButtons(buttons : buttons, pivot: p, end: end)
            }else if !buttons[pivot].isEnabled && !buttons[end].isEnabled {
                let e = end - 1
                reArrangeGridAndDisableButtons(buttons : buttons, pivot: pivot, end: e)
            }
       }//end of recursion lets update something to keep all smooth
        
        self.counterOnPeak = counterOnPeak - itemsRemovedOnArrangements
        //now reset the itemsRemove for future use
        itemsRemovedOnArrangements  = 0
        
    }
    
    
    //this is just an update function to do some great things
    @objc
    func update()
    {
        if inGame{
            game.gameTimer += 1;
          
            //lets flush some colors out
            if(reArrangeButtons)
            {
                reArrangeGridAndDisableButtons(buttons: viewButtons, pivot: 0 , end: counterOnPeak - 1)
                //objectToFlush.removeAll()
                reArrangeButtons = false
            }
            
            if(objectToFlush.count > 0)
            {
                for index in objectToFlush.indices {
                    disableButton(sender: objectToFlush[index])
                }
                
                objectToFlush.removeAll()
                
                //lets re arrange grid
                reArrangeButtons = true
                
            }
            
        }else{
            timer.invalidate()
        }
    }
    
}

