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
    
    //my animator to make cards move :-)
    lazy var animator = UIDynamicAnimator(referenceView: self.view)
    lazy var cardBehavior = CardAnimator(in: animator)
  

    @IBOutlet weak var MainGameView: MainViewGame!
    //this is fun! just to have a nice touch
    var colors = [UIColor.orange, UIColor.cyan, UIColor.yellow, UIColor.lightGray, UIColor.white]
    public var peakSets =  [GameFactorySingleton]()
    
    public var objectToFlush = [SetCardView]()
    public var reArrangeButtons: Bool  = false
    
    //the array to holes all the card view on this grid
    public var viewButtons = [SetCardView]()
    private var needAnimation = [SetCardView]()
    
    //ingame boolean
    var inGame: Bool = false
    var timer: Timer!
    var peakTimer : Int = 0
    var PeakMaxTime = 3
    var starPickTimer: Bool = false
    var counterOnPeak: Int = 0
    //counter to keep track of user finding a set
    var countBeforeFoundSet = 0

    var itemsRemovedOnArrangements: Int = 0
    
    var gameCollection = Dictionary<SetCardView, ModelCards>()
    
    var gameSetBasket  = Dictionary<SetCardView, ModelCards>()
    
    //pointer variable for our game data model :-)
    private lazy var game =  GameDataModel(type: self)
    //global game car pointer
    private var card: ModelDeck!
    
    
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
    func animateButton( button: SetCardView, color: UIColor){
        button.backgroundColor = color
    }
    
     //my fly animation funtion
    func fly_with_animation()
    {
        var delayTime : Double = 0
        let grid = Grid(for: MainGameView.frame, withNoOfFrames: counterOnPeak)
        for indexAnimating in 0..<self.needAnimation.count {
            let gridIndex = self.MainGameView.index(ofAccessibilityElement: needAnimation[indexAnimating])
            delayTime = 0.1 * Double(indexAnimating)
        UIView.animate(withDuration: 0.7,
                       delay: 8,
                       options: .curveEaseInOut,
                       animations: {
                        
                        if(grid[gridIndex] != nil ){
                        self.needAnimation[indexAnimating].frame = grid[gridIndex]!
                        }
        },
                       completion: { finisehed in
                        UIView.transition(with: self.needAnimation[indexAnimating],
                                          duration: 0.2,
                                          options: .transitionFlipFromLeft,
                                          animations: {
                                            self.needAnimation[indexAnimating].isFaceDown = false
                                            self.needAnimation[indexAnimating].setNeedsDisplay()
                                            
                        }, completion: { finisehed in
                           
                            //you can allow interaction if you want here
                        
                        })
        })
    }
    }
    
    //this function is to initialize my game buttons dynamically
    func initGameUiButtons(initDecks: Int)
    {
        viewButtons.removeAll()
        gameCollection.removeAll()
        
         for _ in 0..<initDecks {
             
            if !game.cardDeckObject().isDeckEmpty() {
                let one = card.dealCard()
                let newCard = SetCardView()
                newCard.isHidden = false
                newCard.setIsEnabled(v: true)
                newCard.setObjectCardToRender(card: one!, uiController: self)
                newCard.setCardFaceDown(flip: true)
                self.MainGameView.addSubview(newCard)
                needAnimation.append(newCard)
                viewButtons.append(newCard)
                gameCollection.updateValue(one!, forKey: newCard)
                counterOnPeak = counterOnPeak + 1
            }
            
        }
        
        //print("number of cards deal \(counterOnPeak) ")
        game.computePossibleAlgorithms()
    }
  

    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            break
            //faceCardScale *= recognizer.scale
            //recognizer.scale = 1.0
        default:
            break
        }
    }
    
    //function return my own visible game collection for all cards
    func getGameCollectionUI() -> Dictionary<SetCardView, ModelCards> {
    return self.gameCollection
    }
    //get the game object basket
    func getGameSetBasket() -> Dictionary<SetCardView, ModelCards> {
        return self.gameSetBasket
    }
    
    //this function is going to animate my card on deal and then flip it when it reach its destination
    func animateAndFlipCard(sender: SetCardView){
        UIView.transition(with: sender,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft],
                          animations: {
                            sender.isFaceDown = !sender.isFaceDown
                          },
                          completion: { finished in
                            let cardToAnimate = sender
                                UIViewPropertyAnimator.runningPropertyAnimator(
                                    withDuration: 0.6,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                       
                                            cardToAnimate.transform = CGAffineTransform.identity.scaledBy(x: 0.5,
                                                                                               y: 0.5)
                                },  completion: { finished in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            
                                                 cardToAnimate.transform = CGAffineTransform.identity.scaledBy(x: 0.1,
                                                                                                   y: 0.1)
                                                 cardToAnimate.alpha = 0
                                            
                                    },
                                        completion: { finished in
                                          
                                                 cardToAnimate.isHidden = false
                                                 cardToAnimate.alpha = 1.0
                                                 cardToAnimate.transform = CGAffineTransform.identity
                                          
                                    }
                                    )
                                })
                           })
    }

    
    public func toggle_buttons(sender: SetCardView){
       //lets get the buttons from the hashable key and put it on a basket
        if(inGame){
             sender.backgroundColor = UIColor.cyan
            
            //animate the view as rotation
            UIView.animate(withDuration: 1, animations: {
                sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }) { (finished) in
                UIView.animate(withDuration: 1, animations: {
                    //sender.transform = CGAffineTransform.identity
                })
            }
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
          
            if !viewButtons[index].enabled {
             viewButtons[index].backgroundColor = UIColor.lightGray
            }else{
                viewButtons[index].backgroundColor = UIColor.black
            }
        }
    }
    
    //touch new gsmr button function
    @IBAction func newGame(_ sender: UIButton){
        if !inGame {
         inGame = true
        self.newGame.setTitle("InGame", for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }else{
            restartGame()
        }
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
    
    func restartGame() {
        
        gameCollection.removeAll()
        for index in viewButtons.indices {
            disableButton(sender: viewButtons[index])
        }
        
        viewButtons.removeAll()
        counterOnPeak = 0
        game.score = 0
        game.gameTimer = 0
        // Do any additional setup after loading the view, typically from a nib.
        initGameUiButtons(initDecks: 12)
    }

    
    //touch new gsmr button function
    @IBAction func dealCards(_ sender: UIButton){
        if inGame {
       
            for  _ in 0...2{
                if game.canDealMoreCards() {
                    let one = card.dealCard()
                    let newCard = SetCardView()
                    newCard.isHidden = false
                    newCard.isFaceDown = true;
                    newCard.setIsEnabled(v: true)
                    newCard.setObjectCardToRender(card: one!, uiController: self)
                    self.MainGameView.addSubview(newCard)
                    needAnimation.append(newCard)
                    viewButtons.append(newCard)
                    gameCollection.updateValue(one!, forKey: newCard)
                    counterOnPeak = counterOnPeak + 1
                }
           
            }//close if check
             fly_with_animation()
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
            viewButtons[index].enabled = false;
        }
    }
    
    
    func isThereAnyNotEnabledCardOnGrid() -> Bool {
       for index in  0..<counterOnPeak {
            if !viewButtons[index].enabled{
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
    func disableButton(sender: SetCardView){
     
            sender.enabled = false
            sender.backgroundColor = UIColor.gray
           UIView.animate(withDuration: 1, animations: {
            sender.transform = CGAffineTransform(translationX: self.MainGameView.bounds.size.width, y: self.MainGameView.bounds.size.height )
            }) { (finished) in
            UIView.animate(withDuration: 1, animations: {
                sender.transform = CGAffineTransform.identity
                sender.removeFromSuperview()
            })
          }
        
    
        
      
    }
    
    
    
    //function color set and animate it
    func ColorSetsAndAnimateItOnPeak(rand: Int)
    {
        let randomColor =  rand
        let setFactory =  peakSets[0]
        for dictionary in gameCollection.indices {
            if gameCollection[dictionary].key.enabled {
            let cardT =  gameCollection[dictionary].value
            if setFactory.firstCard.attributedContents() == cardT.attributedContents() {
                animateButton(button: gameCollection[dictionary].key, color: colors[randomColor])
                //animate this buttons
                UIView.animate(withDuration: 1, animations: {
                    self.gameCollection[dictionary].key.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }) { (finished) in
                    UIView.animate(withDuration: 1, animations: {
                        self.gameCollection[dictionary].key.transform = CGAffineTransform.identity
                    })
                }
            }
            if setFactory.secondCard.attributedContents() == cardT.attributedContents() {
                animateButton(button: gameCollection[dictionary].key, color: colors[randomColor])
                //animate this buttons
                UIView.animate(withDuration: 1, animations: {
                    self.gameCollection[dictionary].key.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }) { (finished) in
                    UIView.animate(withDuration: 1, animations: {
                        self.gameCollection[dictionary].key.transform = CGAffineTransform.identity
                    })
                }
                
            }
            if setFactory.thirdCard.attributedContents() == cardT.attributedContents() {
                animateButton(button: gameCollection[dictionary].key, color: colors[randomColor])
                //animate this buttons
                UIView.animate(withDuration: 1, animations: {
                    self.gameCollection[dictionary].key.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }) { (finished) in
                    UIView.animate(withDuration: 1, animations: {
                        self.gameCollection[dictionary].key.transform = CGAffineTransform.identity
                    })
                }
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
                flushColor()
                for index in objectToFlush.indices {
                    self.MainGameView.willRemoveSubview(objectToFlush[index])
                    disableButton(sender: objectToFlush[index])
                    gameCollection.removeValue(forKey: objectToFlush[index])
                    viewButtons.remove(at: index)
                    counterOnPeak = counterOnPeak - 1
                }
              
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
        print("Hello this function has this many subviews ")
        self.view.backgroundColor = UIColor.black
        //set the deck to the cards
        card =  game.cardDeckObject()
        print("The number of subview inside the main view is \(MainGameView.subviews.count)")

        //self.mainCardView.setObjectCardToRender(card: one!)
        
        
        //disable buttons
        disableButtons();
        // Do any additional setup after loading the view, typically from a nib.
        initGameUiButtons(initDecks: 12)
        fly_with_animation();
        
    }
    

}

//compute a random index
extension CGFloat {
    var arc4random: CGFloat {
        return self * CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max)
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
