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
    
    //this is fun! just to have a nice touch
    var colors = [UIColor.orange, UIColor.cyan, UIColor.yellow, UIColor.lightGray, UIColor.white]
    public var peakSets =  [GameFactorySingleton]()
    
    public var objectToFlush = [UIButton]()
    public var reArrangeButtons: Bool  = false
    
    //ingame boolean
    var inGame: Bool = false
    var timer: Timer!
    var peakTimer : Int = 0
    var PeakMaxTime = 8
    var starPickTimer: Bool = false
    var counterOnPeak: Int = 0
    //counter to keep track of user finding a set
    var countBeforeFoundSet = 0

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
    
    //animate UI Buttons
    func animateButton( button: UIButton , color: UIColor){
        button.backgroundColor = color
    }
    
  
    
    //this function is to initialize my game buttons dynamically
    func initGameUiButtons(initDecks: Int)
    {
        gameCollection.removeAll()
        var card = game.cardDeckObject()
        
         for index in 0..<initDecks {
            
            if !game.cardDeckObject().isDeckEmpty() {
                let cardObject =  card.dealCard()
                viewButtons[index].isEnabled  = true;
                viewButtons[index].isHidden = false;
                viewButtons[index].setAttributedTitle(cardObject?.attributedContents(), for: UIControlState.normal)
                viewButtons[index].backgroundColor = UIColor.white
                //insert this nice item to my dictionary
                gameCollection.updateValue(cardObject!, forKey: viewButtons[index])
                counterOnPeak = counterOnPeak + 1
            }
        }
        
        print("number of cards deal \(counterOnPeak) ")
        game.computePossibleAlgorithms()
        
    }
    
    //function return my own visible game collection for all cards
    func getGameCollectionUI() -> Dictionary<UIButton, ModelCards> {
    return self.gameCollection
    }
    //get the game object basket
    func getGameSetBasket() -> Dictionary<UIButton, ModelCards> {
        return self.gameSetBasket
    }
    

    
    @IBAction func toggle_buttons(_ sender: UIButton){
       //lets get the buttons from the hashable key and put it on a basket
        if(inGame){
             sender.backgroundColor = UIColor.cyan
        
            if gameSetBasket[sender] != nil {
                //deselect a basket
                game.score = game.score - 100
                for indexKey in gameSetBasket.keys {
                    if indexKey == sender {
                        gameSetBasket.removeValue(forKey: indexKey)
                        indexKey.backgroundColor = UIColor.white
                    }
                }
            }else{
              gameSetBasket.updateValue(gameCollection[sender]!, forKey: sender)
            }
            
            
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
        for  index in 0..<counterOnPeak
        {
            if !viewButtons[index].isEnabled {
            viewButtons[index].backgroundColor = UIColor.lightGray
            }else{
                viewButtons[index].backgroundColor = UIColor.white
            }
        }
    }
    
    //touch new gsmr button function
    @IBAction func newGame(_ sender: UIButton){
         inGame = true
        self.newGame.setTitle("InGame", for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    //touch peak button function
      @IBAction func peak(_ sender: UIButton){
       //lets do some magic
        if inGame {
        game.AppendANewHintAsSetToViewController()
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
    

    
    //touch new gsmr button function
    @IBAction func dealCards(_ sender: UIButton){
        var counter = 0;
        var card =  game.cardDeckObject()
        if inGame {
            for item in 0..<counterOnPeak {
            
                    if !viewButtons[item].isEnabled {
                    if  counter < 3{
                        let cardObject =  card.dealCard()
                        viewButtons[item].isEnabled  = true;
                        viewButtons[item].isHidden = false;
                        viewButtons[item].setAttributedTitle(cardObject?.attributedContents(), for: UIControlState.normal)
                        viewButtons[item].backgroundColor = UIColor.white
                        //insert this nice item to my dictionary
                        gameCollection.updateValue(cardObject!, forKey: viewButtons[item])
                        counter = counter + 1
                    }
                    
                }
            }
            //lets fill the more cards
            let difference = 2 - counter;
            print("difference is now \(difference) ")
            if(difference > 0 ){
            for  index in 0...difference{
                let pivot = (counterOnPeak) + index
                if game.canDealMoreCards() &&  !viewButtons[pivot].isEnabled {
                    let cardObject =  card.dealCard()
                    viewButtons[pivot].isEnabled  = true;
                    viewButtons[pivot].isHidden = false;
                    viewButtons[pivot].setAttributedTitle(cardObject?.attributedContents(), for: UIControlState.normal)
                    viewButtons[pivot].backgroundColor = UIColor.white
                    //insert this nice item to my dictionary
                    gameCollection.updateValue(cardObject!, forKey: viewButtons[pivot])
                    counter = counter + 1
                }
            }
            }//close if check
            if game.canDealMoreCards() {
            counterOnPeak = counterOnPeak + counter;
            }
          
            game.computePossibleAlgorithms()
          
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
    
    //lets disable our buttons
    func disableButtons()
    {
        for index in viewButtons.indices {
            viewButtons[index].isHidden = true;
            viewButtons[index].isEnabled = false;
        }
    }
    
    
    func isThereAnyNotEnabledCardOnGrid() -> Bool {
        for index in  0..<counterOnPeak {
            if !viewButtons[index].isEnabled{
                return true
            }
        }
        return false
    }
    
    //lets diable deal 3 cards button base on logic if there is no more cards to deal
    func disableThreeMoreCardsButtonIfNeeded() {
        if !game.canDealMoreCards()
            && (game.cardDeckObject().getTotalDeck() == 0)
            && !isThereAnyNotEnabledCardOnGrid(){
             deal.isHidden = true
        }
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
    
    
    
    //function color set and animate it
    func ColorSetsAndAnimateItOnPeak(rand: Int)
    {
        let randomColor =  rand
        let setFactory =  peakSets[0]
        for dictionary in gameCollection.indices {
            if gameCollection[dictionary].key.isEnabled {
            let card =  gameCollection[dictionary].value
            if setFactory.firstCard.attributedContents() == card.attributedContents() {
                animateButton(button: gameCollection[dictionary].key, color: colors[randomColor])
            }
            if setFactory.secondCard.attributedContents() == card.attributedContents() {
                animateButton(button: gameCollection[dictionary].key, color: colors[randomColor])
            }
            if setFactory.thirdCard.attributedContents() == card.attributedContents() {
                animateButton(button: gameCollection[dictionary].key, color: colors[randomColor])
            }
            }//close if check 
            
        }//close for 
    }
    
    //this is just an update function to do some great things
    @objc
    func update()
    {
        if inGame{
            game.gameTimer += 1;
            countBeforeFoundSet = countBeforeFoundSet + 1
          
            //lets flush some colors out
            if(reArrangeButtons)
            {
               // reArrangeGridAndDisableButtons(buttons: viewButtons, pivot: 0 , end: counterOnPeak - 1)
                //objectToFlush.removeAll()
                reArrangeButtons = false
            }
            
            if(objectToFlush.count > 0)
            {
                for index in objectToFlush.indices {
                    disableButton(sender: objectToFlush[index])
                }
                //flushcolor
                flushColor()
                objectToFlush.removeAll()
                //dinamycally find and compute more sets
                  game.computePossibleAlgorithms()
                //lets re arrange grid
                reArrangeButtons = true
            }
            
            //the peak timer
            if starPickTimer {
                
                if peakTimer < PeakMaxTime {
                    if peakSets.count > 0 {
                        let random  =  colors.count.arc4ramd
                        ColorSetsAndAnimateItOnPeak(rand: random)
                        }
                }else{
                    //go off
                    if peakSets.count > 0 {
                    let random  =  colors.count - 1
                    ColorSetsAndAnimateItOnPeak(rand: random)
                    }
                    peakTimer = 0
                    starPickTimer = false
                }
              peakTimer = peakTimer + 1
            }
        
         //disable deal button if needed
         updateAndStyleScore()
         disableThreeMoreCardsButtonIfNeeded()
        }else{
            timer.invalidate()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        //disable buttons
        //disableButtons();
        // Do any additional setup after loading the view, typically from a nib.
        //initGameUiButtons(initDecks: 12)
        
    }
    

}

//compute a random index
extension Int {
    var arc4ramd: Int {
        if(self > 0){
            return Int(arc4random_uniform(UInt32(self)))
        }else if( self < 0 ){
            return Int(arc4random_uniform(UInt32(-self)))
        }else{
            return 0
        }
    }
}
